import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../feeds/community_chat_feed.dart';
import '../feeds/community_posts_feed.dart';
import '../resolvers.dart';
import '../providers/current_profile.dart';

class CommunityScreen extends ConsumerWidget {
  final Community community;

  const CommunityScreen({
    super.key,
    required this.community,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentProfile = ref.watch(currentProfileProvider);
    final resolvers = ref.read(resolversProvider);

    // Get available content types from the community
    final contentTypes =
        <String, ({int count, Widget feed, Widget bottomBar})>{};

    print('Community content sections: ${community.contentSections}');

    for (final section in community.contentSections) {
      print('Processing section: ${section.content}');
      // Convert community content type to design system format
      final contentType = section.content;

      switch (contentType) {
        case 'Chat':
          contentTypes['welcome'] = (
            count: 0,
            feed: AppCommunityWelcomeFeed(
              community: community,
              onProfileTap: () => context.push(
                  '/chat/${community.author.value?.pubkey}/info',
                  extra: community),
            ),
            bottomBar: const AppBottomBarWelcome()
          );
          contentTypes['chat'] = (
            count: 12,
            feed: CommunityChatFeed(community: community),
            bottomBar: AppBottomBarChat(
              onAddTap: () {},
              onMessageTap: () {},
              onVoiceTap: () {},
              onActions: () {},
              onResolveEvent: resolvers.eventResolver,
              onResolveProfile: resolvers.profileResolver,
              onResolveEmoji: resolvers.emojiResolver,
            )
          );
          break;
        case 'Posts':
          print('Found Posts section');
          contentTypes['post'] = (
            count: 0,
            feed: CommunityPostsFeed(community: community),
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
            count: 0,
            feed: AppLoadingFeed(type: LoadingFeedType.content),
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
            feed: AppLoadingFeed(type: LoadingFeedType.content),
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
        case 'Images':
          contentTypes['image'] = (
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
              '/chat/${community.author.value?.pubkey}/info',
              extra: community),
        ),
        bottomBar: const AppBottomBarWelcome()
      );
    }

    return AppCommunityScreen(
      community: community,
      onProfileTap: () => context.push(
          '/chat/${community.author.value?.pubkey}/info',
          extra: community),
      currentProfile: currentProfile!,
      mainCount: 0,
      contentTypes: contentTypes,
      onHomeTap: () => context.pop(),
      onActions: (event) => context.push('/actions/${event.id}', extra: event),
      onReply: (event) {},
      onReactionTap: (event) {},
      onZapTap: (event) {},
      onLinkTap: (url) {},
      onResolveEvent: resolvers.eventResolver,
      onResolveProfile: resolvers.profileResolver,
      onResolveEmoji: resolvers.emojiResolver,
      onResolveHashtag: (identifier) async {
        await Future.delayed(const Duration(seconds: 1));
        return () {};
      },
    );
  }
}
