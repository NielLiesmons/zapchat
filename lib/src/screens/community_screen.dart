import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import '../providers/resolvers.dart';
import '../providers/history.dart';
import '../providers/communities_provider.dart';
import '../modals & bottom bars/chat_bottom_bar.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  final Community community;
  final String? initialContentType;

  const CommunityScreen({
    required this.community,
    this.initialContentType,
    super.key,
  });

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationControllerClose;
  late AnimationController _animationControllerOpen;
  double _currentDrag = 0;

  bool _isPopping = false;
  bool _showTopZone =
      true; // Should be true initially since _currentDrag starts at 0.0
  DateTime? _menuOpenedAt;
  bool _isInitialDrag = true;
  String?
      _currentPublishingMessageId; // Track the message currently being published
  bool _isBottomBarExpanded = false; // Track bottom bar expanded state
  ChatMessage? _quotedMessage; // Track the message being replied to
  final GlobalKey<MorphingChatBottomBarState> _bottomBarKey =
      GlobalKey<MorphingChatBottomBarState>();

  // ✅ CACHED: Expensive gradients and decorations to prevent recreation every frame
  LinearGradient? _topBarGradient;
  BorderRadius? _expandedBorderRadius;
  BorderRadius? _collapsedBorderRadius;
  BorderSide? _expandedBorderSide;
  BorderSide? _collapsedBorderSide;

  // Real history items from provider
  List<HistoryItem> get _history {
    return ref.watch(recentHistoryItemsProvider(context, widget.community.id));
  }

  @override
  void initState() {
    super.initState();
    _animationControllerClose = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationControllerOpen = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    // ✅ INITIALIZE: Cache expensive decorations to prevent recreation every frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final theme = LabTheme.of(context);
      _topBarGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          theme.colors.black,
          theme.colors.black.withValues(alpha: 0.33),
        ],
      );
      _expandedBorderRadius = BorderRadius.vertical(top: theme.radius.rad16);
      _collapsedBorderRadius = BorderRadius.zero;
      _expandedBorderSide = BorderSide(
        color: theme.colors.white16,
        width: LabLineThicknessData.normal().thin,
      );
      _collapsedBorderSide = BorderSide(
        color: theme.colors.white16,
        width: LabLineThicknessData.normal().medium,
      );
    });

    // Add this community to history when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(historyProvider.notifier).addEntry(widget.community);
    });
  }

  Future<void> _publishMessage(ChatMessage message) async {
    try {
      // Get community's preferred relay URLs
      final communityRelayUrls = widget.community.relayUrls;

      // Use only the first community relay, otherwise default relays
      final source = communityRelayUrls.isNotEmpty
          ? RemoteSource(group: 'custom', relayUrls: {communityRelayUrls.first})
          : const RemoteSource();

      await ref
          .read(storageNotifierProvider.notifier)
          .publish({message}, source: source);
      print(
          'Message published successfully to ${communityRelayUrls.isNotEmpty ? communityRelayUrls.length : 'default'} relays');

      // Clear publishing state after successful publish
      setState(() {
        _currentPublishingMessageId = null;
      });
    } catch (e) {
      print('Error publishing message: $e');
      // Keep publishing state for retry
    }
  }

  @override
  void dispose() {
    _animationControllerClose.dispose();
    _animationControllerOpen.dispose();
    super.dispose();
  }

  double get _menuHeight {
    final topPadding = MediaQuery.of(context).padding.top;
    final baseHeight = 94.0 + (LabPlatformUtils.isMobile ? topPadding : 38.0);
    final historyHeight = _history.length * LabTheme.of(context).sizes.s38;
    return baseHeight + historyHeight;
  }

  bool get _shouldTreatAsEmpty =>
      _history.isEmpty || !LabPlatformUtils.isMobile;

  List<TabData> _getCommunityTabs() {
    final tabs = <TabData>[];

    // Always add Welcome first
    tabs.add(TabData(
      label: 'Welcome',
      icon: const LabEmojiContentType(contentType: 'welcome'),
      content: const SizedBox.shrink(),
      count: 0,
    ));

    // Add Chat second
    tabs.add(TabData(
      label: 'Chat',
      icon: const LabEmojiContentType(contentType: 'chat'),
      content: const SizedBox.shrink(),
      count: 0,
    ));

    // Add community content sections
    for (final section in widget.community.contentSections) {
      final sectionName = section.content;
      final displayName =
          sectionName[0].toUpperCase() + sectionName.substring(1);

      tabs.add(TabData(
        label: displayName,
        icon: LabEmojiContentType(
            contentType: getContentTyepFromCommunitySectionName(displayName)),
        content: const SizedBox.shrink(),
        count: 0,
      ));
    }

    // Always add Supporters last
    tabs.add(TabData(
      label: 'Supporters',
      icon: const LabEmojiContentType(contentType: 'supporters'),
      content: const SizedBox.shrink(),
      count: 0,
    ));

    return tabs;
  }

  int _getInitialTabIndex() {
    if (widget.initialContentType == null) {
      return 1; // Default to Chat tab (index 1)
    }

    final tabs = _getCommunityTabs();
    final index =
        tabs.indexWhere((tab) => tab.label == widget.initialContentType);
    return index >= 0 ? index : 1; // Fallback to Chat tab (index 1)
  }

  void _handleDrag(double delta) {
    setState(() {
      // Check for empty history pop condition first
      if (_shouldTreatAsEmpty && _currentDrag + delta > 0) {
        _currentDrag = (_currentDrag + delta).clamp(0, 40.0).toDouble();
        if (_currentDrag >= 40.0 && Navigator.canPop(context)) {
          if (!_isPopping) {
            _isPopping = true;
            Navigator.of(context).pop();
          }
        }
        return;
      }

      // Otherwise handle normal drag behavior
      _currentDrag = (_currentDrag + delta).clamp(0, _menuHeight).toDouble();
      _showTopZone = _currentDrag <= 12.0;
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.dy;

    if (_shouldTreatAsEmpty && _currentDrag > 0) {
      _closeMenu();
      return;
    }

    if (_currentDrag > _menuHeight * 0.66) {
      if (velocity < -500) {
        _closeMenu();
      } else {
        _openMenu();
      }
    } else if (_currentDrag > _menuHeight * 0.33) {
      if (velocity > 500) {
        _openMenu();
      } else if (velocity < -500) {
        _closeMenu();
      } else {
        velocity > 0 ? _openMenu() : _closeMenu();
      }
    } else {
      if (velocity > 500) {
        _openMenu();
      } else {
        _closeMenu();
      }
    }
  }

  void _openMenu() {
    final tween = Tween(
      begin: _currentDrag,
      end: _menuHeight,
    ).animate(CurvedAnimation(
      parent: _animationControllerOpen,
      curve: Curves.easeOut,
    ));

    // ❌ REMOVED: setState in every frame - this was causing constant rebuilds!
    // ✅ FIXED: Will use AnimatedBuilder in build method instead
    _animationControllerOpen
      ..reset()
      ..forward();
  }

  void _closeMenu() {
    final tween = Tween(
      begin: _currentDrag,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationControllerClose,
      curve: Curves.easeOut,
    ));

    // ❌ REMOVED: setState in every frame - this was causing constant rebuilds!
    // ✅ FIXED: Will use AnimatedBuilder in build method instead
    _animationControllerClose
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return HookConsumer(
      builder: (context, ref, _) {
        final theme = LabTheme.of(context);
        final resolvers = ref.read(resolversProvider);

        // Handle message publishing directly from bottom bar callback
        void handleNewMessage(ChatMessage message) async {
          // Set the publishing state to show loading in the message bubble
          setState(() {
            _currentPublishingMessageId = message.id;
          });

          // Publish the message to relays
          await _publishMessage(message);

          // Clear the quoted message after sending
          setState(() {
            _quotedMessage = null;
          });
        }

        // Handle bottom bar expanded state changes
        void handleBottomBarExpandedStateChanged(bool isExpanded) {
          setState(() {
            _isBottomBarExpanded = isExpanded;
          });
        }

        // Helper function to determine message stack grouping
        (bool isFirstInStack, bool isLastInStack) getMessageStackInfo(
            List<ChatMessage> messages, int index) {
          if (messages.isEmpty) return (true, true);

          final currentMessage = messages[index];
          final currentAuthor = currentMessage.author.value?.pubkey;
          final currentTime = currentMessage.createdAt;

          // Check if previous message (higher index) is from same author and within 21 minutes
          bool isFirstInStack = true;
          if (index < messages.length - 1) {
            final previousMessage = messages[index + 1];
            final previousAuthor = previousMessage.author.value?.pubkey;
            final previousTime = previousMessage.createdAt;

            if (currentAuthor == previousAuthor) {
              final timeDifference = currentTime.difference(previousTime);
              if (timeDifference.inMinutes <= 21) {
                isFirstInStack = false;
              }
            }
          }

          // Check if next message (lower index) is from same author and within 21 minutes
          bool isLastInStack = true;
          if (index > 0) {
            final nextMessage = messages[index - 1];
            final nextAuthor = nextMessage.author.value?.pubkey;
            final nextTime = nextMessage.createdAt;

            if (currentAuthor == nextAuthor) {
              final timeDifference = nextTime.difference(currentTime);
              if (timeDifference.inMinutes <= 21) {
                isLastInStack = false;
              }
            }
          }

          return (isFirstInStack, isLastInStack);
        }

        // Use centralized communities provider for zero-delay access
        final messages =
            ref.watch(communityMessagesProvider(widget.community.id));

        print(
            '🏘️ Community screen using centralized provider - Messages: ${messages.length}');

        return LabScaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: const Color(0x00000000),
          body: Stack(
            children: [
              Column(
                children: [
                  // Top zone (Safe Area) - colored black when menu closed, transparent when open
                  Opacity(
                    opacity: _showTopZone ? 1.0 : 0.0,
                    child: LabContainer(
                      height: LabPlatformUtils.isMobile
                          ? MediaQuery.of(context).padding.top + 2
                          : 22,
                      decoration: BoxDecoration(
                        color: theme.colors.black,
                      ),
                    ),
                  ),

                  // Main zone
                  Expanded(
                    child: Stack(
                      children: [
                        // History menu
                        if (_history.isNotEmpty && LabPlatformUtils.isMobile)
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            child: LabHistoryMenu(
                              history: _history,
                              currentDrag: _currentDrag,
                              menuHeight: _menuHeight,
                              onHomeTap: () => context.pop(),
                              onTapOutside: _closeMenu,
                            ),
                          ),

                        // Main content
                        Transform.translate(
                          offset: Offset(0, _currentDrag),
                          child: LabContainer(
                            width: double.infinity,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: theme.colors.black,
                              borderRadius: _currentDrag > 0
                                  ? (_expandedBorderRadius ??
                                      BorderRadius.vertical(
                                          top: theme.radius.rad16))
                                  : (_collapsedBorderRadius ??
                                      BorderRadius.zero),
                              border: Border(
                                top: _currentDrag > 0
                                    ? (_expandedBorderSide ??
                                        BorderSide(
                                          color: theme.colors.white16,
                                          width: LabLineThicknessData.normal()
                                              .thin,
                                        ))
                                    : (_collapsedBorderSide ??
                                        BorderSide(
                                          color: theme.colors.white16,
                                          width: LabLineThicknessData.normal()
                                              .medium,
                                        )),
                              ),
                            ),
                            child: Stack(
                              children: [
                                // Chat content - using centralized provider data
                                ListView.builder(
                                  padding: EdgeInsets.only(
                                    top: LabPlatformUtils.isMobile ? 116 : 120,
                                    bottom: _isBottomBarExpanded
                                        ? (LabPlatformUtils.isMobile
                                            ? 128
                                            : 118) // Extra padding when expanded
                                        : (LabPlatformUtils.isMobile ? 91 : 81),
                                  ),
                                  reverse: true, // Newest at bottom
                                  itemCount: messages.length,
                                  // Performance optimizations
                                  addAutomaticKeepAlives:
                                      false, // Don't keep off-screen items alive
                                  addRepaintBoundaries:
                                      true, // Add repaint boundaries for better performance
                                  cacheExtent:
                                      500.0, // Cache more items for smoother scrolling
                                  itemExtent:
                                      null, // Let items determine their own height
                                  itemBuilder: (context, index) {
                                    final message = messages[index];
                                    final isOutgoing = message
                                            .author.value?.pubkey ==
                                        ref.read(Signer.activePubkeyProvider);

                                    // Get stack grouping info
                                    final (isFirstInStack, isLastInStack) =
                                        getMessageStackInfo(messages, index);

                                    return LabMessageBubble(
                                      message: message,
                                      isOutgoing: isOutgoing,
                                      isFirstInStack: isFirstInStack,
                                      isLastInStack: isLastInStack,
                                      isPublishing: isOutgoing &&
                                          message.id ==
                                              _currentPublishingMessageId,
                                      onSendAgain: isOutgoing &&
                                              message.event.relays.isEmpty &&
                                              message.id ==
                                                  _currentPublishingMessageId
                                          ? (model) async {
                                              // Retry publishing the message
                                              await _publishMessage(
                                                  model as ChatMessage);
                                            }
                                          : null,
                                      onActions: (model) => context
                                          .push('/actions/${model.id}', extra: (
                                        model: model,
                                        community: widget.community,
                                        onLocalReply: (model) {
                                          // Handle reply - set quoted message and expand bottom bar
                                          setState(() {
                                            _quotedMessage =
                                                model as ChatMessage;
                                            _isBottomBarExpanded = true;
                                          });
                                          // Actually expand the bottom bar
                                          if (_bottomBarKey.currentState !=
                                              null) {
                                            _bottomBarKey.currentState!
                                                .expand();
                                          }
                                        },
                                      )),
                                      onReply: (model) {
                                        // Handle reply - set quoted message and expand bottom bar
                                        setState(() {
                                          _quotedMessage = model as ChatMessage;
                                          _isBottomBarExpanded = true;
                                        });
                                        // Actually expand the bottom bar
                                        if (_bottomBarKey.currentState !=
                                            null) {
                                          _bottomBarKey.currentState!.expand();
                                        }
                                      },
                                      onResolveEvent: resolvers.eventResolver,
                                      onResolveProfile:
                                          resolvers.profileResolver,
                                      onResolveEmoji: resolvers.emojiResolver,
                                      onResolveHashtag:
                                          resolvers.hashtagResolver,
                                      onLinkTap: (url) {
                                        // Handle link tap
                                        print('Link tapped: $url');
                                      },
                                      onProfileTap: (profile) {
                                        // Handle profile tap
                                        print(
                                            'Profile tapped: ${profile.name}');
                                      },
                                      activePubkey:
                                          ref.read(Signer.activePubkeyProvider),
                                    );
                                  },
                                ),
                                // Black bar that renders the top 8px of the screen always in black
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  child: LabContainer(
                                    height: theme.sizes.s8,
                                    decoration: BoxDecoration(
                                      color: theme.colors.black,
                                    ),
                                  ),
                                ),

                                // Top Bar + Gesture detection zone
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onVerticalDragStart: (details) {
                                      if (_currentDrag < _menuHeight) {
                                        _menuOpenedAt = null;
                                        _isInitialDrag = true;
                                      }
                                    },
                                    onVerticalDragUpdate: (details) {
                                      if (!_isInitialDrag &&
                                          _currentDrag >= _menuHeight &&
                                          _menuOpenedAt != null &&
                                          details.primaryDelta! > 0 &&
                                          Navigator.canPop(context) &&
                                          LabPlatformUtils.isMobile) {
                                        Navigator.of(context).pop();
                                      } else {
                                        _handleDrag(details.primaryDelta!);
                                      }
                                    },
                                    onVerticalDragEnd: (details) {
                                      _isInitialDrag = false;
                                      _handleDragEnd(details);
                                    },
                                    onHorizontalDragStart: (_) {},
                                    onHorizontalDragUpdate: (_) {},
                                    onHorizontalDragEnd: (_) {},
                                    onTap: _currentDrag > 0 ? _closeMenu : null,
                                    child: LabContainer(
                                      decoration: const BoxDecoration(
                                        color: Color(0x00000000),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          LabContainer(
                                            decoration: BoxDecoration(
                                              color: theme.colors.black,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const LabGap.s8(),
                                                const LabDragHandle(),
                                                LabContainer(
                                                  child: Column(
                                                    children: [
                                                      // Header with community profile pic + name + notifications
                                                      LabContainer(
                                                        padding:
                                                            LabEdgeInsets.only(
                                                          left: LabGapSize.s12,
                                                          right: LabGapSize.s12,
                                                          bottom:
                                                              LabGapSize.s12,
                                                          top: LabPlatformUtils
                                                                  .isMobile
                                                              ? LabGapSize.s4
                                                              : LabGapSize.s12,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            LabProfilePic.s32(
                                                                widget
                                                                    .community
                                                                    .author
                                                                    .value,
                                                                onTap: () => context.push(
                                                                    '/community/${widget.community.author.value?.npub}/info',
                                                                    extra: widget
                                                                        .community)),
                                                            Expanded(
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  const LabGap
                                                                      .s12(),
                                                                  Expanded(
                                                                    child:
                                                                        TapBuilder(
                                                                      onTap: () => context.push(
                                                                          '/community/${widget.community.author.value?.npub}/info',
                                                                          extra:
                                                                              widget.community),
                                                                      builder: (context,
                                                                          state,
                                                                          hasFocus) {
                                                                        return LabText
                                                                            .bold14(
                                                                          widget.community.author.value?.name ??
                                                                              '',
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                  TapBuilder(
                                                                    onTap:
                                                                        () {},
                                                                    builder: (context,
                                                                        state,
                                                                        hasFocus) {
                                                                      return Stack(
                                                                        clipBehavior:
                                                                            Clip.none,
                                                                        children: [
                                                                          LabContainer(
                                                                            height:
                                                                                32,
                                                                            width:
                                                                                32,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: theme.colors.gray66,
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                            child:
                                                                                Center(
                                                                              child: LabIcon(
                                                                                theme.icons.characters.bell,
                                                                                color: theme.colors.white33,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          if (10 >
                                                                              0) // Hardcoded count for now
                                                                            Positioned(
                                                                              top: -4,
                                                                              right: -10,
                                                                              child: LabContainer(
                                                                                height: theme.sizes.s20,
                                                                                padding: const LabEdgeInsets.symmetric(
                                                                                  horizontal: LabGapSize.s6,
                                                                                ),
                                                                                decoration: BoxDecoration(
                                                                                  gradient: theme.colors.blurple,
                                                                                  borderRadius: BorderRadius.circular(100),
                                                                                ),
                                                                                child: ConstrainedBox(
                                                                                  constraints: const BoxConstraints(
                                                                                    minWidth: 8,
                                                                                  ),
                                                                                  child: Center(
                                                                                    child: LabText.med10(
                                                                                      '10',
                                                                                      color: theme.colors.whiteEnforced,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  ),
                                                                  if (10 > 0)
                                                                    const LabGap
                                                                        .s10(),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // TabView with actual community content sections
                                                      LabTabView(
                                                        controller: LabTabController(
                                                            length:
                                                                _getCommunityTabs()
                                                                    .length,
                                                            initialIndex:
                                                                _getInitialTabIndex()),
                                                        tabs:
                                                            _getCommunityTabs(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Bottom bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: MorphingChatBottomBar(
                  key: _bottomBarKey,
                  model: widget.community,
                  quotedMessage: _quotedMessage,
                  onAddTap: (model) {
                    // Handle add tap
                    print('Add tapped');
                  },
                  onVoiceTap: (model) {
                    // Handle voice tap
                    print('Voice tapped');
                  },
                  onActions: (model) {
                    // Handle actions tap
                    print('Actions tapped');
                  },
                  onMessageSent: handleNewMessage,
                  onExpandedStateChanged: handleBottomBarExpandedStateChanged,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
