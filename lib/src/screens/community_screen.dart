import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:models/models.dart';
import 'package:tap_builder/tap_builder.dart';
import '../feeds/community_welcome_feed.dart';
import '../feeds/community_chat_feed.dart';
import '../feeds/community_threads_feed.dart';
import '../feeds/community_articles_feed.dart';
import '../feeds/community_jobs_feed.dart';
import '../feeds/community_books_feed.dart';
import '../feeds/comunity_polls_feed.dart';
import '../feeds/community_services_feed.dart';
import '../feeds/community_forum_feed.dart';
import '../feeds/community_products_feed.dart';
import '../feeds/community_supporters_feed.dart';
import '../providers/resolvers.dart';
import '../providers/history.dart';

class CommunityScreen extends StatefulHookConsumerWidget {
  final Community community;
  final String? initialContentType;

  const CommunityScreen({
    super.key,
    required this.community,
    this.initialContentType,
  });

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  late final LabTabController _tabController;
  late Map<String, ({int count, Widget feed, Widget bottomBar})> _contentTypes;

  @override
  void initState() {
    super.initState();
    _contentTypes = _buildContentTypes();

    // Calculate initial index safely
    int initialIndex = 0;
    if (widget.initialContentType != null) {
      final index =
          _contentTypes.keys.toList().indexOf(widget.initialContentType!);
      initialIndex = index >= 0 ? index : 0;
    }

    _tabController = LabTabController(
      length: _contentTypes.length,
      initialIndex: initialIndex,
    );
    _tabController.addListener(() {
      if (_tabController.index < 0 ||
          _tabController.index >= _contentTypes.length) {
        _tabController.animateTo(0);
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Map<String, ({int count, Widget feed, Widget bottomBar})>
      _buildContentTypes() {
    final contentTypes =
        <String, ({int count, Widget feed, Widget bottomBar})>{};
    final resolvers = ref.read(resolversProvider);

    // DEBUG: Print community data to understand the structure
    print('DEBUG: Community name: ${widget.community.name}');
    print(
        'DEBUG: Community contentSections count: ${widget.community.contentSections.length}');
    for (final section in widget.community.contentSections) {
      print(
          'DEBUG: Content section: "${section.content}" with kinds: ${section.kinds}');
    }

    // 1. Always add hardcoded sections
    contentTypes['Welcome'] = (
      count: 0,
      feed: LabCommunityWelcomeFeed(
        community: widget.community,
        onProfileTap: () => context.push(
            '/community/${widget.community.author.value?.npub}/info',
            extra: widget.community),
      ),
      bottomBar: const LabBottomBarWelcome()
    );

    contentTypes['Chat'] = (
      count: 2,
      feed: CommunityChatFeed(
        community: widget.community,
      ),
      bottomBar: LabBottomBarChat(
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
      )
    );

    // 2. Process Community content sections
    for (final section in widget.community.contentSections) {
      final sectionName = section.content;
      final kinds = section.kinds;

      // Simple mapping: check name + kinds for custom feeds
      if ((sectionName == 'Threads' || sectionName == 'Posts') &&
          kinds.contains(1)) {
        contentTypes['Threads'] = (
          count: 6,
          feed: CommunityThreadsFeed(community: widget.community),
          bottomBar: const LabBottomBarContentFeed()
        );
      } else if (sectionName == 'Articles' && kinds.contains(30023)) {
        contentTypes['Articles'] = (
          count: 4,
          feed: CommunityArticlesFeed(community: widget.community),
          bottomBar: const LabBottomBarContentFeed()
        );
      } else if (sectionName == 'Jobs' && kinds.contains(9041)) {
        contentTypes['Jobs'] = (
          count: 0,
          feed: CommunityJobsFeed(community: widget.community),
          bottomBar: const LabBottomBarContentFeed()
        );
      } else if (sectionName == 'Books' && kinds.contains(30008)) {
        contentTypes['Books'] = (
          count: 0,
          feed: CommunityBooksFeed(community: widget.community),
          bottomBar: const LabBottomBarContentFeed()
        );
      } else if (sectionName == 'Polls' && kinds.contains(1068)) {
        contentTypes['Polls'] = (
          count: 0,
          feed: CommunityPollsFeed(community: widget.community),
          bottomBar: const LabBottomBarContentFeed()
        );
      } else if (sectionName == 'Forum' && kinds.contains(30001)) {
        contentTypes['Forum'] = (
          count: 0,
          feed: CommunityForumFeed(community: widget.community),
          bottomBar: const LabBottomBarContentFeed()
        );
      } else if (sectionName == 'Products' && kinds.contains(30009)) {
        contentTypes['Products'] = (
          count: 0,
          feed: CommunityProductsFeed(community: widget.community),
          bottomBar: const LabBottomBarContentFeed()
        );
      } else if (sectionName == 'Services' && kinds.contains(30010)) {
        contentTypes['Services'] = (
          count: 0,
          feed: CommunityServicesFeed(community: widget.community),
          bottomBar: const LabBottomBarContentFeed()
        );
      } else {
        // Default: use capitalized name + generic feed
        final displayName =
            sectionName[0].toUpperCase() + sectionName.substring(1);
        contentTypes[displayName] = (
          count: 0,
          feed: LabLoadingFeed(
              type: LoadingFeedType
                  .content), // TODO: Replace with generic feed that takes kinds
          bottomBar: const LabBottomBarContentFeed()
        );
        print(
            'DEBUG: Created default tab for: "$sectionName" -> "$displayName" with kinds: $kinds');
      }
    }

    // 3. Always add Supporters section last
    contentTypes['Supporters'] = (
      count: 0,
      feed: CommunitySupportersFeed(community: widget.community),
      bottomBar: const LabBottomBarContentFeed()
    );

    print('DEBUG: Final content types: ${contentTypes.keys.toList()}');
    return contentTypes;
  }

  Widget _buildTopBar(BuildContext context) {
    final theme = LabTheme.of(context);
    final contentTypes = _contentTypes.keys.toList();
    final mainCount = _contentTypes.values.first.count;

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
                    TapBuilder(
                      onTap: () {},
                      builder: (context, state, hasFocus) {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            LabContainer(
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                color: theme.colors.gray66,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: LabIcon(
                                  theme.icons.characters.bell,
                                  color: theme.colors.white33,
                                ),
                              ),
                            ),
                            if (mainCount > 0)
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
                                        '$mainCount',
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
                    if (mainCount > 0) const LabGap.s10(),
                  ],
                ),
              ),
            ],
          ),
        ),
        LabTabView(
          controller: _tabController,
          tabs: [
            for (final contentType in contentTypes)
              TabData(
                label: contentType,
                icon: LabEmojiContentType(
                    contentType:
                        getContentTyepFromCommunitySectionName(contentType)),
                content: const SizedBox.shrink(),
                count: _contentTypes[contentType]?.count ?? 0,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent() {
    final contentTypes = _contentTypes.keys.toList();
    if (_tabController.index < 0 ||
        _tabController.index >= contentTypes.length) {
      return const SizedBox.shrink();
    }
    final selectedType = contentTypes[_tabController.index];
    return _contentTypes[selectedType]?.feed ?? const SizedBox.shrink();
  }

  Widget _buildBottomBar() {
    final contentTypes = _contentTypes.keys.toList();
    if (_tabController.index < 0 ||
        _tabController.index >= contentTypes.length) {
      return const SizedBox.shrink();
    }
    final selectedType = contentTypes[_tabController.index];
    return _contentTypes[selectedType]?.bottomBar ?? const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    // Record in history
    ref.read(historyProvider.notifier).addEntry(widget.community);
    final recentHistory =
        ref.watch(recentHistoryItemsProvider(context, widget.community.id));

    // Watch profiles to ensure author data is loaded for fallback logic
    ref.watch(query<Profile>());

    // Safely determine if we should start at bottom
    bool startAtBottom = false;
    if (_tabController.index >= 0 &&
        _tabController.index < _contentTypes.length) {
      final currentTab = _contentTypes.keys.toList()[_tabController.index];
      startAtBottom = currentTab == 'Chat';
    }

    return LabScreen(
      alwaysShowTopBar: true,
      customTopBar: true,
      bottomBarContent: _buildBottomBar(),
      topBarContent: _buildTopBar(context),
      onHomeTap: () => context.push('/'),
      history: recentHistory,
      scrollable: false,
      startAtBottom: startAtBottom,
      child: LabContainer(
        decoration: BoxDecoration(color: LabTheme.of(context).colors.black),
        clipBehavior: Clip.hardEdge,
        height: MediaQuery.of(context).size.height / theme.system.scale -
            (16 +
                (LabPlatformUtils.isMobile
                    ? MediaQuery.of(context).padding.top
                    : 20)),
        width: double.infinity,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          clipBehavior: Clip.none,
          child: Column(
            children: [
              const LabGap.s80(),
              const LabGap.s24(),
              const LabGap.s2(),
              _buildContent(),
              SizedBox(
                height: LabPlatformUtils.isMobile ? 60 : 70,
              ),
              const LabBottomSafeArea()
            ],
          ),
        ),
      ),
    );
  }
}
