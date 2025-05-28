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
import '../feeds/community_services_feed.dart';
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
  late final AppTabController _tabController;
  late Map<String, ({int count, Widget feed, Widget bottomBar})> _contentTypes;

  @override
  void initState() {
    super.initState();
    _contentTypes = _buildContentTypes();
    _tabController = AppTabController(
      length: _contentTypes.length,
      initialIndex: widget.initialContentType != null
          ? _contentTypes.keys.toList().indexOf(widget.initialContentType!)
          : 0,
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

    for (final section in widget.community.contentSections) {
      final contentType = section.content;

      switch (contentType) {
        case 'Chat':
          contentTypes['welcome'] = (
            count: 0,
            feed: AppCommunityWelcomeFeed(
              community: widget.community,
              onProfileTap: () => context.push(
                  '/community/${widget.community.author.value?.npub}/info',
                  extra: widget.community),
            ),
            bottomBar: const AppBottomBarWelcome()
          );
          contentTypes['chat'] = (
            count: 2,
            feed: CommunityChatFeed(community: widget.community),
            bottomBar: AppBottomBarChat(
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
          break;
        case 'Threads':
          contentTypes['thread'] = (
            count: 6,
            feed: CommunityThreadsFeed(community: widget.community),
            bottomBar: const AppBottomBarContentFeed()
          );
          break;
        case 'Tasks':
          contentTypes['task'] = (
            count: 0,
            feed: AppLoadingFeed(type: LoadingFeedType.content),
            bottomBar: const AppBottomBarContentFeed()
          );
          break;
        case 'Jobs':
          contentTypes['job'] = (
            count: 0,
            feed: CommunityJobsFeed(community: widget.community),
            bottomBar: const AppBottomBarContentFeed()
          );
          break;
        case 'Services':
          contentTypes['service'] = (
            count: 0,
            feed: CommunityServicesFeed(community: widget.community),
            bottomBar: const AppBottomBarContentFeed()
          );
          break;
        case 'Docs':
          contentTypes['doc'] = (
            count: 0,
            feed: AppLoadingFeed(type: LoadingFeedType.content),
            bottomBar: const AppBottomBarContentFeed()
          );
          break;
        case 'Articles':
          contentTypes['article'] = (
            count: 4,
            feed: CommunityArticlesFeed(community: widget.community),
            bottomBar: const AppBottomBarContentFeed()
          );
          break;
        case 'Polls':
          contentTypes['poll'] = (
            count: 0,
            feed: AppLoadingFeed(type: LoadingFeedType.content),
            bottomBar: const AppBottomBarContentFeed()
          );
          break;
        case 'Apps':
          contentTypes['app'] = (
            count: 0,
            feed: AppLoadingFeed(type: LoadingFeedType.content),
            bottomBar: const AppBottomBarContentFeed()
          );
          break;
        case 'Work-outs':
          contentTypes['work-out'] = (
            count: 0,
            feed: AppLoadingFeed(type: LoadingFeedType.content),
            bottomBar: const AppBottomBarContentFeed()
          );
          break;
        case 'Books':
          contentTypes['book'] = (
            count: 0,
            feed: CommunityBooksFeed(community: widget.community),
            bottomBar: const AppBottomBarContentFeed()
          );
          break;
        case 'Videos':
          contentTypes['video'] = (
            count: 0,
            feed: AppLoadingFeed(type: LoadingFeedType.content),
            bottomBar: const AppBottomBarContentFeed()
          );
          break;
        case 'Albums':
          contentTypes['album'] = (
            count: 0,
            feed: AppLoadingFeed(type: LoadingFeedType.content),
            bottomBar: const AppBottomBarContentFeed()
          );
          break;
        default:
          contentTypes[section.content] = (
            count: 0,
            feed: AppLoadingFeed(type: LoadingFeedType.content),
            bottomBar: const AppBottomBarContentFeed()
          );
      }
    }

    if (contentTypes.isEmpty) {
      contentTypes['welcome'] = (
        count: 0,
        feed: AppCommunityWelcomeFeed(
          community: widget.community,
          onProfileTap: () => context.push(
              '/community/${widget.community.author.value?.npub}/info',
              extra: widget.community),
        ),
        bottomBar: const AppBottomBarWelcome()
      );
    }

    return contentTypes;
  }

  Widget _buildTopBar(BuildContext context) {
    final theme = AppTheme.of(context);
    final contentTypes = _contentTypes.keys.toList();
    final mainCount = _contentTypes.values.first.count;

    return Column(
      children: [
        AppContainer(
          padding: const AppEdgeInsets.only(
            left: AppGapSize.s12,
            right: AppGapSize.s12,
            top: AppGapSize.s4,
            bottom: AppGapSize.s12,
          ),
          child: Row(
            children: [
              AppProfilePic.s32(widget.community.author.value,
                  onTap: () => context.push(
                      '/community/${widget.community.author.value?.npub}/info',
                      extra: widget.community)),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const AppGap.s12(),
                    Expanded(
                      child: TapBuilder(
                        onTap: () => context.push(
                            '/community/${widget.community.author.value?.npub}/info',
                            extra: widget.community),
                        builder: (context, state, hasFocus) {
                          return AppText.bold14(
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
                            AppContainer(
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                color: theme.colors.gray66,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: AppIcon(
                                  theme.icons.characters.bell,
                                  color: theme.colors.white33,
                                ),
                              ),
                            ),
                            if (mainCount > 0)
                              Positioned(
                                top: -4,
                                right: -10,
                                child: AppContainer(
                                  height: theme.sizes.s20,
                                  padding: const AppEdgeInsets.symmetric(
                                    horizontal: AppGapSize.s6,
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
                                      child: AppText.med10(
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
                    if (mainCount > 0) const AppGap.s10(),
                  ],
                ),
              ),
            ],
          ),
        ),
        AppTabView(
          controller: _tabController,
          tabs: [
            for (final contentType in contentTypes)
              TabData(
                label: ['chat', 'welcome', 'forum'].contains(contentType)
                    ? '${contentType[0].toUpperCase()}${contentType.substring(1)}'
                    : '${contentType[0].toUpperCase()}${contentType.substring(1)}s',
                icon: AppEmojiContentType(contentType: contentType),
                content: const SizedBox(),
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
    // Record in history
    ref.read(historyProvider.notifier).addEntry(widget.community);
    final recentHistory =
        ref.watch(recentHistoryItemsProvider(context, widget.community.id));

    return AppScreen(
      alwaysShowTopBar: true,
      customTopBar: true,
      bottomBarContent: _buildBottomBar(),
      topBarContent: _buildTopBar(context),
      onHomeTap: () => context.push('/'),
      history: recentHistory,
      child: AppContainer(
        decoration: BoxDecoration(color: AppTheme.of(context).colors.black),
        clipBehavior: Clip.hardEdge,
        width: double.infinity,
        child: Column(
          children: [
            const AppGap.s80(),
            const AppGap.s24(),
            const AppGap.s2(),
            _buildContent(),
          ],
        ),
      ),
    );
  }
}
