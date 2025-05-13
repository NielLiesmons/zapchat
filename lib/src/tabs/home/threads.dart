import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:go_router/go_router.dart';
import '../../providers/resolvers.dart';

class ThreadsTab extends StatelessWidget {
  const ThreadsTab({super.key});

  TabData tabData(BuildContext context) {
    return TabData(
      label: 'Threads',
      icon: const AppEmojiContentType(contentType: 'thread'),
      content: HookConsumer(
        builder: (context, ref, _) {
          final state = ref.watch(query<Note>());

          if (state case StorageLoading()) {
            return const AppLoadingFeed(type: LoadingFeedType.thread);
          }

          final threads = state.models.cast<Note>();

          return Column(
            children: [
              for (final thread in threads)
                AppFeedThread(
                  thread: thread,
                  onTap: (event) =>
                      context.push('/thread/${event.id}', extra: event),
                  onReply: (event) =>
                      context.push('/reply-to/${event.id}', extra: event),
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
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => tabData(context).content;
}
