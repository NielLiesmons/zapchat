import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter/scheduler.dart';
import 'dart:ui';
import '../modals & bottom bars/chat_bottom_bar.dart';
import '../providers/resolvers.dart';
import '../providers/url_launcher_provider.dart';
import '../feeds/community_chat_feed.dart';
import '../feeds/community_welcome_feed.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  final Community community;
  final String? initialContentType;
  final String? activePubkey;

  const CommunityScreen({
    required this.community,
    this.initialContentType,
    this.activePubkey,
    super.key,
  });

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
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

  late LabTabController _tabController;

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

    // Initialize TabController
    _tabController = LabTabController(
      length: _getCommunityTabs().length,
      initialIndex: _getInitialTabIndex(),
    );

    // Add listener to update content when tab changes
    _tabController.addListener(() {
      setState(() {
        // This will trigger a rebuild and show the correct tab content
      });
    });

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

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationControllerClose.dispose();
    _animationControllerOpen.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Lifecycle management can be added later
  }

  double get _menuHeight {
    final topPadding = MediaQuery.viewPaddingOf(context).top;
    final baseHeight = 94.0 + (topPadding > 0 ? topPadding : 38.0);
    return baseHeight;
  }

  bool get _shouldTreatAsEmpty => true; // Simplified for test app

  List<Widget> _buildTabContent() {
    final tabs = _getCommunityTabs();
    final content = <Widget>[];

    for (int i = 0; i < tabs.length; i++) {
      final tab = tabs[i];
      Widget tabContent;

      switch (tab.label.toLowerCase()) {
        case 'welcome':
          // Welcome tab - NO state preservation needed
          tabContent = LabCommunityWelcomeFeed(
            community: widget.community,
            onProfileTap: () {
              // Handle profile tap if needed
            },
          );
          break;
        case 'chat':
          // Chat tab - MUST preserve state (scroll position, etc.)
          tabContent = CommunityChatFeed(
            community: widget.community,
            activePubkey: widget.activePubkey,
          );
          break;
        case 'supporters':
          // Supporters tab - NO state preservation needed
          tabContent = _buildSupportersContent();
          break;
        default:
          // Community sections - check if this is a Chat section
          if (tab.label.toLowerCase() == 'chat') {
            // Chat section from community contentSections - MUST preserve state
            tabContent = CommunityChatFeed(
              community: widget.community,
              activePubkey: widget.activePubkey,
            );
          } else {
            // Other community sections - NO state preservation needed
            tabContent = _buildCommunitySectionContent(tab.label);
          }
          break;
      }

      // Only wrap tabs that need state preservation in IndexedStack
      if (tab.label.toLowerCase() == 'chat') {
        content.add(IndexedStack(
          index: 0,
          children: [tabContent],
        ));
      } else {
        // For tabs that don't need state preservation, create fresh each time
        content.add(tabContent);
      }
    }

    return content;
  }

  Widget _buildSupportersContent() {
    return const SizedBox.shrink(); // TODO: Add supporters feed
  }

  Widget _buildCommunitySectionContent(String sectionName) {
    return const SizedBox.shrink(); // TODO: Add $sectionName feed
  }

  List<TabData> _getCommunityTabs() {
    final tabs = <TabData>[];

    // Always add Welcome first
    tabs.add(TabData(
      label: 'Welcome',
      icon: const LabEmojiContentType(contentType: 'welcome'),
      content: const SizedBox.shrink(),
      count: 0,
    ));

    // Check if community already has a Chat section
    final hasChatSection = widget.community.contentSections
        .any((section) => section.content.toLowerCase() == 'chat');

    // Only add hardcoded Chat tab if community doesn't already have one
    if (!hasChatSection) {
      tabs.add(TabData(
        label: 'Chat',
        icon: const LabEmojiContentType(contentType: 'chat'),
        content: const SizedBox.shrink(),
        count: 0,
      ));
    }

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
      // Find the Chat tab index (could be from hardcoded or community sections)
      final tabs = _getCommunityTabs();
      final chatIndex =
          tabs.indexWhere((tab) => tab.label.toLowerCase() == 'chat');
      return chatIndex >= 0
          ? chatIndex
          : 1; // Fallback to index 1 if no Chat tab found
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
        _currentDrag = (_currentDrag + delta).clamp(0, 80.0).toDouble();
        if (_currentDrag >= 80.0 && Navigator.canPop(context)) {
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

    tween.addListener(() {
      // Use addPostFrameCallback to avoid build during frame
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _currentDrag = tween.value;
            if (_currentDrag >= _menuHeight) {
              _menuOpenedAt = DateTime.now();
            }
          });
        }
      });
    });

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

    tween.addListener(() {
      // Use addPostFrameCallback to avoid build during frame
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _currentDrag = tween.value;
            _showTopZone = _currentDrag <= 12.0;
          });
        }
      });
    });

    _animationControllerClose
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final theme = LabTheme.of(context);

        return LabScaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: const Color(0x00000000),
          body: Column(
            children: [
              // Top zone (Safe Area) - colored black when menu closed, transparent when open
              Opacity(
                opacity: _showTopZone ? 1.0 : 0.0,
                child: LabContainer(
                  height: MediaQuery.viewPaddingOf(context).top + 2,
                  decoration: BoxDecoration(
                    color: theme.colors.black,
                  ),
                ),
              ),

              // Main zone
              Expanded(
                child: Stack(
                  children: [
                    // Main content - with drag animation
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
                              : (_collapsedBorderRadius ?? BorderRadius.zero),
                          border: Border(
                            top: _currentDrag > 0
                                ? (_expandedBorderSide ??
                                    BorderSide(
                                      color: theme.colors.white16,
                                      width: LabLineThicknessData.normal().thin,
                                    ))
                                : (_collapsedBorderSide ??
                                    BorderSide(
                                      color: theme.colors.white16,
                                      width:
                                          LabLineThicknessData.normal().medium,
                                    )),
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Tab content - state-preserving with IndexedStack
                            IndexedStack(
                              index: _tabController.index,
                              children: _buildTabContent(),
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
                                      Navigator.canPop(context)) {
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
                                  height: _currentDrag > 0 ? 2000 : null,
                                  decoration: const BoxDecoration(
                                    color: Color(0x00000000),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ClipRRect(
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 14, sigmaY: 14),
                                          child: LabContainer(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  theme.colors.black,
                                                  theme.colors.black
                                                      .withValues(alpha: 0.33),
                                                ],
                                              ),
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
                                                            const LabEdgeInsets
                                                                .only(
                                                          left: LabGapSize.s12,
                                                          right: LabGapSize.s12,
                                                          bottom:
                                                              LabGapSize.s12,
                                                          top: LabGapSize.s4,
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
                                                                        GestureDetector(
                                                                      onTap: () => context.push(
                                                                          '/community/${widget.community.author.value?.npub}/info',
                                                                          extra:
                                                                              widget.community),
                                                                      child: LabText
                                                                          .bold14(
                                                                        widget.community.author.value?.name ??
                                                                            '',
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const LabGap
                                                                      .s12(),
                                                                  if (ref.watch(
                                                                          Signer
                                                                              .activePubkeyProvider) ==
                                                                      widget
                                                                          .community
                                                                          .author
                                                                          .value
                                                                          ?.event
                                                                          .pubkey)
                                                                    GestureDetector(
                                                                      onTap: () =>
                                                                          context
                                                                              .push(
                                                                        '/create/community/configure',
                                                                        extra: {
                                                                          'profile': widget
                                                                              .community
                                                                              .author
                                                                              .value!,
                                                                          'communityName': widget
                                                                              .community
                                                                              .name,
                                                                        },
                                                                      ),
                                                                      child:
                                                                          LabContainer(
                                                                        height:
                                                                            32,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          gradient: theme
                                                                              .colors
                                                                              .gold16,
                                                                          borderRadius:
                                                                              BorderRadius.circular(100),
                                                                        ),
                                                                        padding:
                                                                            const LabEdgeInsets.symmetric(
                                                                          horizontal:
                                                                              LabGapSize.s12,
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              LabIcon.s14(
                                                                            theme.icons.characters.crown,
                                                                            gradient:
                                                                                theme.colors.gold,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  const LabGap
                                                                      .s12(),
                                                                  GestureDetector(
                                                                    onTap:
                                                                        () {},
                                                                    child:
                                                                        Stack(
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
                                                                            color:
                                                                                theme.colors.gray66,
                                                                            shape:
                                                                                BoxShape.circle,
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                LabIcon(
                                                                              theme.icons.characters.bell,
                                                                              color: theme.colors.white33,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        if (10 >
                                                                            0) // Hardcoded count for now
                                                                          Positioned(
                                                                            top:
                                                                                -4,
                                                                            right:
                                                                                -10,
                                                                            child:
                                                                                LabContainer(
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
                                                                    ),
                                                                  ),
                                                                  // Add "Your Community" button if user is the author

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
                                                        controller:
                                                            _tabController,
                                                        tabs:
                                                            _getCommunityTabs(),
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
        );
      },
    );
  }
}
