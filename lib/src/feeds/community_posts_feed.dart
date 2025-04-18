import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../resolvers.dart';
import '../providers/user_profiles.dart';

class CommunityPostsFeed extends ConsumerWidget {
  final Community community;

  const CommunityPostsFeed({
    super.key,
    required this.community,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(queryType<Note>());

    if (state case StorageLoading()) {
      return const AppLoadingFeed();
    }

    final posts = state.models.cast<Note>();

    return Column(
      children: [
        for (final post in posts)
          AppFeedPost(
            post: post,
            onReply: (event) =>
                context.push('/reply/${event.id}', extra: event),
            onActions: (event) =>
                context.push('/actions/${event.id}', extra: event),
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
