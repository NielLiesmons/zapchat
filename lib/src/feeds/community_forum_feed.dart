import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/resolvers.dart';

class CommunityForumFeed extends ConsumerWidget {
  final Community community;

  const CommunityForumFeed({
    super.key,
    required this.community,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(query<ForumPost>());

    if (state case StorageLoading()) {
      return const AppLoadingFeed(type: LoadingFeedType.thread);
    }

    final forumPosts = state.models.cast<ForumPost>();

    return Column(
      children: [
        for (final forumPost in forumPosts)
          AppFeedForumPost(
            forumPost: forumPost,
            onTap: (model) => context.push('/forum/${model.id}', extra: model),
            onReply: (model) =>
                context.push('/reply-to/${model.id}', extra: model),
            onActions: (model) =>
                context.push('/actions/${model.id}', extra: model),
            onReactionTap: (reaction) {},
            onZapTap: (zap) {},
            onResolveEvent: ref.read(resolversProvider).eventResolver,
            onResolveProfile: ref.read(resolversProvider).profileResolver,
            onResolveEmoji: ref.read(resolversProvider).emojiResolver,
            onResolveHashtag: ref.read(resolversProvider).hashtagResolver,
            onLinkTap: (url) {
              print(url);
            },
            onProfileTap: (profile) =>
                context.push('/profile/${profile.npub}', extra: profile),
          ),
      ],
    );
  }
}
