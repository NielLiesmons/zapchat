import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/resolvers.dart';
import '../providers/user_profiles.dart';

class CommunityPostsFeed extends ConsumerWidget {
  final Community community;

  const CommunityPostsFeed({
    super.key,
    required this.community,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(query<Note>());

    if (state case StorageLoading()) {
      return const AppLoadingFeed(type: LoadingFeedType.post);
    }

    final posts = state.models.cast<Note>();

    return Column(
      children: [
        for (final post in posts)
          AppFeedPost(
            post: post,
            onTap: (model) => context.push('/post/${model.id}', extra: model),
            onReply: (model) =>
                context.push('/reply/${model.id}', extra: model),
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
          ),
      ],
    );
  }
}
