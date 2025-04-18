import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:go_router/go_router.dart';
import '../providers/resolvers.dart';

class PostsTab extends StatelessWidget {
  const PostsTab({super.key});

  TabData tabData(BuildContext context) {
    return TabData(
      label: 'Posts',
      icon: const AppEmojiContentType(contentType: 'post'),
      content: HookConsumer(
        builder: (context, ref, _) {
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
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => tabData(context).content;
}
