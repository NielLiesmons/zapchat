import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:models/models.dart';
import '../feeds/community_welcome_feed.dart';
import '../feeds/community_chat_feed.dart';
import '../feeds/community_threads_feed.dart';
import '../feeds/community_articles_feed.dart';
import '../feeds/community_jobs_feed.dart';
import '../feeds/community_books_feed.dart';
import '../providers/resolvers.dart';
import '../providers/history.dart';

class CommunityScreen extends HookConsumerWidget {
  final Community community;
  final String? initialContentType;

  const CommunityScreen({
    super.key,
    required this.community,
    this.initialContentType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // history
    ref.read(historyProvider.notifier).addEntry(community); // Record in history
    final recentHistory = ref.watch(recentHistoryItemsProvider(
        context, community.id)); // Get latest 3 history entries

    // Resolvers
    final resolvers = ref.read(resolversProvider);

    // Get data
    final currentProfile = ref.watch(Profile.signedInProfileProvider);

    final contentTypes =
        <String, ({int count, Widget feed, Widget bottomBar})>{};

    for (final section in community.contentSections) {
      // Convert community content type to design system format
      final contentType = section.content;

      switch (contentType) {
        case 'Chat':
          contentTypes['welcome'] = (
            count: 0,
            feed: AppCommunityWelcomeFeed(
              community: community,
              onProfileTap: () => context.push(
                  '/community/${community.author.value?.npub}/info',
                  extra: community),
            ),
            bottomBar: const AppBottomBarWelcome()
          );
          contentTypes['chat'] = (
            count: 2,
            feed: CommunityChatFeed(community: community),
            bottomBar: AppBottomBarChat(
              model: community,
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
            feed: CommunityThreadsFeed(community: community),
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
            feed: CommunityJobsFeed(community: community),
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
            feed: CommunityArticlesFeed(community: community),
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
            feed: CommunityBooksFeed(community: community),
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
          // For unknown content types, use the original string
          contentTypes[section.content] = (
            count: 0,
            feed: AppLoadingFeed(type: LoadingFeedType.content),
            bottomBar: const AppBottomBarContentFeed()
          );
      }
    }

    // Add welcome content type if no other content types are found
    if (contentTypes.isEmpty) {
      contentTypes['welcome'] = (
        count: 0,
        feed: AppCommunityWelcomeFeed(
          community: community,
          onProfileTap: () => context.push(
              '/community/${community.author.value?.npub}/info',
              extra: community),
        ),
        bottomBar: const AppBottomBarWelcome()
      );
    }

    // Find the index of the initial content type
    final contentTypesList = contentTypes.keys.toList();
    final initialTab = initialContentType != null
        ? contentTypesList.indexOf(initialContentType!)
        : null;

    return AppCommunityScreen(
      community: community,
      onProfileTap: () => context.push(
          '/community/${community.author.value?.npub}/info',
          extra: community),
      currentProfile: currentProfile!,
      contentTypes: contentTypes,
      mainCount: contentTypes.values.first.count,
      onHomeTap: () => context.push('/'),
      onNotificationsTap: () {},
      onResolveEvent: resolvers.eventResolver,
      onResolveProfile: resolvers.profileResolver,
      onResolveEmoji: resolvers.emojiResolver,
      onResolveHashtag: resolvers.hashtagResolver,
      onLinkTap: (url) {},
      onActions: (model) {},
      onReply: (model) {},
      onReactionTap: (reaction) {},
      onZapTap: (zap) {},
      initialTab: initialTab,
      history: recentHistory,
    );
  }
}
