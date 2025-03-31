import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';

class PostsTab extends StatelessWidget {
  const PostsTab({super.key});

  TabData tabData(BuildContext context) {
    return TabData(
      label: 'Posts',
      icon: const AppEmojiContentType(contentType: 'post'),
      content: HookConsumer(
        builder: (context, ref, _) {
          final state = ref.watch(query(kinds: {1}));

          useMemoized(() async {
            ref.read(storageNotifierProvider.notifier).generateDummyFor(
                  pubkey:
                      'a9434ee165ed01b286becfc2771ef1705d3537d051b387288898cc00d5c885be',
                  kind: 1,
                );
          });

          if (state case StorageLoading()) {
            return const Center(child: AppLoadingDots());
          }

          final posts = state.models.cast<Post>();

          return Column(
            children: [
              for (final post in posts)
                AppFeedPost(
                  nevent: post.nevent,
                  content: post.content,
                  profileName: post.profileName,
                  profilePicUrl: post.profilePicUrl,
                  timestamp: post.timestamp,
                  onResolveEvent: (identifier) async {
                    // Simulate network delay
                    await Future.delayed(const Duration(seconds: 1));
                    final events = await ref.read(storageProvider).queryAsync(
                          RequestFilter(
                            kinds: {30023},
                            authors: {
                              'a9434ee165ed01b286becfc2771ef1705d3537d051b387288898cc00d5c885be'
                            },
                            limit: 1,
                          ),
                        );
                    return events.cast<Article>().first;
                  },
                  onResolveProfile: (identifier) async {
                    await Future.delayed(const Duration(seconds: 1));
                    return Profile(
                      npub: identifier,
                      profileName: 'Pip',
                      profilePicUrl: 'https://m.primal.net/IfSZ.jpg',
                    );
                  },
                  onResolveEmoji: (identifier) async {
                    await Future.delayed(const Duration(seconds: 1));
                    return 'https://cdn.satellite.earth/eb0122af34cf27ba7c8248d72294c32a956209f157aa9d697c7cdd6b054f9ea9.png';
                  },
                  onResolveHashtag: (identifier) async {
                    await Future.delayed(const Duration(seconds: 1));
                    return () {};
                  },
                  onLinkTap: (url) {
                    print(url);
                  },
                  onReply: (nevent) {
                    print(nevent);
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
