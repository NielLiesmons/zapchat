import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/resolvers.dart';

class CommunityThreadsFeed extends ConsumerWidget {
  final Community community;

  const CommunityThreadsFeed({
    super.key,
    required this.community,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(query<Note>());

    if (state case StorageLoading()) {
      return const LabLoadingFeed(type: LoadingFeedType.thread);
    }

    final threads = state.models.cast<Note>();
    final resolvers = ref.read(resolversProvider);

    return Column(
      children: [
        for (final thread in threads)
          LabFeedThread(
            thread: thread,
            topThreeReplyProfiles:
                ref.watch(resolvers.topThreeReplyProfilesResolver(thread)),
            totalReplyProfiles:
                ref.watch(resolvers.totalReplyProfilesResolver(thread)),
            onTap: (model) => context.push('/thread/${model.id}', extra: model),
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
