import 'dart:ui';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:flutter/scheduler.dart';
import 'package:zaplab_design/src/notifications/scroll_progress_notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';

import '../feeds/community_chat_feed.dart';
import '../feeds/community_threads_feed.dart';
import '../providers/history.dart';
import '../providers/resolvers.dart';

class CustomCommunityScreen extends ConsumerStatefulWidget {
  final Community community;

  const CustomCommunityScreen({
    super.key,
    required this.community,
  });

  @override
  ConsumerState<CustomCommunityScreen> createState() =>
      _CustomCommunityScreenState();
}

class _CustomCommunityScreenState extends ConsumerState<CustomCommunityScreen>
    with TickerProviderStateMixin {
  static const double _buttonHeight = 38.0;
  static const double _buttonWidthDelta = 32.0;
  static const double _topBarHeight = 64.0;

  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationControllerClose;
  late AnimationController _animationControllerOpen;
  late LabTabController _tabController;
  bool _showTopZone = false;
  double _currentDrag = 0;
  bool _isAtTop = true;
  DateTime? _menuOpenedAt;
  bool _showTopBarContent = false;
  bool _isInitialDrag = true;
  bool _isPopping = false;
  bool _showScrollToBottomButton = false;

  @override
  void initState() {
    super.initState();
    _tabController = LabTabController(length: 2, initialIndex: 0);

    final controller = _scrollController;
    controller.addListener(_handleScroll);
    _animationControllerOpen = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _animationControllerClose = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Initialize _showTopBarContent
    _showTopBarContent = true;

    // Record in history
    ref.read(historyProvider.notifier).addEntry(widget.community);

    // Wait for the initial build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _showTopZone = true);
    });
  }

  @override
  void dispose() {
    _animationControllerOpen.dispose();
    _animationControllerClose.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  double get _menuHeight {
    final topPadding = MediaQuery.of(context).padding.top;
    final baseHeight = 94.0 + (LabPlatformUtils.isMobile ? topPadding : 38.0);
    return baseHeight;
  }

  bool get _shouldTreatAsEmpty => !LabPlatformUtils.isMobile;

  void _handleScroll() {
    final controller = _scrollController;

    setState(() {
      _isAtTop = controller.offset <= 0;
      _showTopBarContent = controller.offset > 2;

      // Show scroll button when scrolling past 100px
      if (controller.hasClients) {
        _showScrollToBottomButton = controller.offset > 320;
      }
    });

    final maxScroll = controller.position.maxScrollExtent;
    if (maxScroll > 0) {
      final progress = controller.offset / maxScroll;
      ScrollProgressNotification(progress, context).dispatch();
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
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _currentDrag = tween.value;
            _showTopZone = _currentDrag <= 7.0;
          });
        }
      });
    });

    _animationControllerClose
      ..reset()
      ..forward();
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
      _showTopZone = _currentDrag <= 7.0;
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

  Widget _buildTopBarContent() {
    final theme = LabTheme.of(context);

    return Column(
      children: [
        LabContainer(
          padding: const LabEdgeInsets.only(
            left: LabGapSize.s12,
            right: LabGapSize.s12,
            top: LabGapSize.s4,
            bottom: LabGapSize.s12,
          ),
          child: Row(
            children: [
              LabProfilePic.s32(widget.community.author.value,
                  onTap: () => context.push(
                      '/community/${widget.community.author.value?.npub}/info',
                      extra: widget.community)),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const LabGap.s12(),
                    Expanded(
                      child: TapBuilder(
                        onTap: () => context.push(
                            '/community/${widget.community.author.value?.npub}/info',
                            extra: widget.community),
                        builder: (context, state, hasFocus) {
                          return LabText.bold14(
                            widget.community.author.value?.name ?? '',
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        LabTabView(
          controller: _tabController,
          tabs: [
            TabData(
              label: 'Chat',
              icon: LabEmojiContentType(
                  contentType: getContentTyepFromCommunitySectionName('Chat')),
              content: const SizedBox.shrink(),
              count: 0,
            ),
            TabData(
              label: 'Threads',
              icon: LabEmojiContentType(
                  contentType:
                      getContentTyepFromCommunitySectionName('Threads')),
              content: const SizedBox.shrink(),
              count: 0,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return IndexedStack(
      index: _tabController.index,
      children: [
        // Chat tab
        CommunityChatFeed(community: widget.community),
        // Threads tab
        CommunityThreadsFeed(community: widget.community),
      ],
    );
  }

  Widget _buildBottomBar() {
    final resolvers = ref.read(resolversProvider);

    if (_tabController.index == 0) {
      // Chat bottom bar
      return LabBottomBarChat(
        model: widget.community,
        onAddTap: (model) {},
        onMessageTap: (model) {
          context.push('/create/message', extra: model);
        },
        onVoiceTap: (model) {},
        onActions: (model) {},
        onResolveEvent: resolvers.eventResolver,
        onResolveProfile: resolvers.profileResolver,
        onResolveEmoji: resolvers.emojiResolver,
      );
    } else {
      // Threads bottom bar
      return const LabBottomBarContentFeed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final progress = _currentDrag / _menuHeight;

    return Stack(
      children: [
        Column(
          children: [
            // Top zone (Safe Area)
            Opacity(
              opacity: _showTopZone ? 1.0 : 0.0,
              child: LabContainer(
                height: LabPlatformUtils.isMobile
                    ? MediaQuery.of(context).padding.top + 2
                    : 22,
                decoration: BoxDecoration(
                  color: _currentDrag < 5
                      ? theme.colors.black
                      : theme.colors.black33,
                ),
              ),
            ),

            // Main zone
            Expanded(
              child: Stack(
                children: [
                  // Main content
                  Transform.translate(
                    offset: Offset(0, _currentDrag),
                    child: LabContainer(
                      width: double.infinity,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: theme.colors.black,
                        borderRadius: BorderRadius.vertical(
                          top: progress > 0 ? theme.radius.rad16 : Radius.zero,
                        ),
                        border: Border(
                          top: BorderSide(
                            color: theme.colors.white16,
                            width: _currentDrag > 0
                                ? LabLineThicknessData.normal().thin
                                : LabLineThicknessData.normal().medium,
                          ),
                        ),
                      ),
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height *
                                theme.system.scale -
                            (_topBarHeight +
                                (LabPlatformUtils.isMobile
                                    ? MediaQuery.of(context).padding.top
                                    : 20)),
                      ),
                      child: LabScaffold(
                        body: Stack(
                          children: [
                            // Scrollable content that goes under the top bar
                            Positioned(
                              child: NotificationListener<ScrollNotification>(
                                onNotification: (notification) {
                                  if (notification.metrics.axis !=
                                      Axis.vertical) {
                                    return false;
                                  }

                                  if (notification
                                      is ScrollUpdateNotification) {
                                    if (_isAtTop &&
                                        notification.metrics.pixels < 0) {
                                      if (notification.dragDetails != null) {
                                        _handleDrag(
                                            -notification.metrics.pixels * 0.2);
                                        return true;
                                      } else if (_currentDrag > 0) {
                                        if (_currentDrag > _menuHeight * 0.33) {
                                          _openMenu();
                                        } else {
                                          _closeMenu();
                                        }
                                        return true;
                                      }
                                    }
                                  }
                                  return false;
                                },
                                child: SingleChildScrollView(
                                  controller: _scrollController,
                                  physics: const AlwaysScrollableScrollPhysics(
                                    parent: BouncingScrollPhysics(),
                                  ),
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minHeight: 480,
                                    ),
                                    child: Column(
                                      children: [
                                        // Top padding
                                        const LabGap.s10(),
                                        // Actual content
                                        _buildMainContent(),
                                        // Bottom bar space
                                        SizedBox(
                                          height: LabPlatformUtils.isMobile
                                              ? 60
                                              : 70,
                                        ),
                                        const LabBottomSafeArea(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Black bar at top
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
                                  height: _currentDrag > 0 ? 2000 : null,
                                  decoration: const BoxDecoration(
                                    color: Color(0x00000000),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ClipRRect(
                                        child: BackdropFilter(
                                          filter: _showTopBarContent
                                              ? ImageFilter.blur(
                                                  sigmaX: 24,
                                                  sigmaY: 24,
                                                )
                                              : ImageFilter.blur(
                                                  sigmaX: 0, sigmaY: 0),
                                          child: LabContainer(
                                            decoration: BoxDecoration(
                                              gradient: _showTopBarContent
                                                  ? LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        theme.colors.black,
                                                        theme.colors.black
                                                            .withValues(
                                                                alpha: 0.33),
                                                      ],
                                                    )
                                                  : null,
                                              color: _showTopBarContent
                                                  ? null
                                                  : const Color(0x00000000),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const LabGap.s8(),
                                                const LabDragHandle(),
                                                if (_showTopBarContent) ...[
                                                  AnimatedContainer(
                                                    duration: const Duration(
                                                        milliseconds: 100),
                                                    height: !_scrollController
                                                                .hasClients ||
                                                            _scrollController
                                                                    .offset <
                                                                2
                                                        ? 0.0
                                                        : _scrollController
                                                                    .offset >
                                                                68
                                                            ? null
                                                            : (_scrollController
                                                                        .offset -
                                                                    2) /
                                                                66 *
                                                                68,
                                                    child: (!_scrollController
                                                                .hasClients ||
                                                            _scrollController
                                                                    .offset >=
                                                                68)
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              if (_scrollController
                                                                  .hasClients) {
                                                                _scrollController
                                                                    .animateTo(
                                                                  0,
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          300),
                                                                  curve: Curves
                                                                      .easeOut,
                                                                );
                                                              }
                                                            },
                                                            child: MouseRegion(
                                                              cursor: LabPlatformUtils
                                                                      .isDesktop
                                                                  ? SystemMouseCursors
                                                                      .click
                                                                  : MouseCursor
                                                                      .defer,
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      LabContainer(
                                                                        padding:
                                                                            LabEdgeInsets.only(
                                                                          left:
                                                                              LabGapSize.s12,
                                                                          right:
                                                                              LabGapSize.s12,
                                                                          bottom: LabPlatformUtils.isMobile
                                                                              ? LabGapSize.s12
                                                                              : LabGapSize.s10,
                                                                        ),
                                                                        child:
                                                                            _buildTopBarContent(),
                                                                      ),
                                                                      const LabDivider(),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        : const Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              SizedBox(
                                                                  width: double
                                                                      .infinity),
                                                              Spacer(),
                                                              LabDivider(),
                                                            ],
                                                          ),
                                                  ),
                                                ],
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
                  ),
                ],
              ),
            ),
          ],
        ),
        // Bottom bar
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildBottomBar(),
        ),

        // Floating scroll to bottom button
        if (_showScrollToBottomButton)
          Positioned(
            right: theme.sizes.s16,
            bottom:
                theme.sizes.s16 + 70.0 + MediaQuery.of(context).padding.bottom,
            child: LabFloatingButton(
              icon: LabIcon.s12(
                theme.icons.characters.arrowUp,
                outlineThickness: LabLineThicknessData.normal().medium,
                outlineColor: theme.colors.white66,
              ),
              onTap: () {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    0,
                    duration: LabDurationsData.normal().normal,
                    curve: Curves.easeOut,
                  );
                }
              },
            ),
          ),
      ],
    );
  }
}
