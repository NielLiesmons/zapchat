import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PostsTab extends StatelessWidget {
  const PostsTab({super.key});

  TabData tabData(BuildContext context) {
    return TabData(
      label: 'Posts',
      icon: const AppEmojiContentType(contentType: 'post'),
      content: HookConsumer(
        builder: (context, ref, _) {
          final state = ref.watch(query(kinds: {1}));

          // useMemoized(() async {
          //   ref.read(storageNotifierProvider.notifier).generateDummyFor(
          //       pubkey:
          //           'a9434ee165ed01b286becfc2771ef1705d3537d051b387288898cc00d5c885be',
          //       kind: 1);
          // });

          if (state case StorageLoading()) {
            return Center(child: CircularProgressIndicator());
          }

          final posts = state.models.cast<Note>();

          return Column(
            children: [
              for (final post in posts)
                AppFeedPost(
                  nevent: post.internal.nevent,
                  content: post.content,
                  profileName: post.author.value!.name ?? '',
                  profilePicUrl: post.author.value!.pictureUrl!,
                  timestamp: post.createdAt,
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
                    return await PartialProfile(
                      name: 'Pip',
                      pictureUrl: 'https://m.primal.net/IfSZ.jpg',
                    ).signWith(DummySigner());
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
              // AppFeedPost(
              //   nevent: '1',
              //   content:
              //       'I love that the UX is the same for all conversations in here. Chat, replies, threads, ... you can just swipe on them.',
              //   profileName: 'Youser Naim',
              //   profilePicUrl:
              //       'https://img.freepik.com/premium-photo/girl-happy-portrait-user-profile-by-ai_1119669-10.jpg',
              //   timestamp: DateTime.now(),
              //   onResolveEvent: (identifier) async {
              //     // Simulate network delay
              //     await Future.delayed(const Duration(seconds: 1));
              //     return NostrEvent(
              //       npub:
              //           'npub1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq',
              //       nevent:
              //           'nevent1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq',
              //       contentType: 'article',
              //       title: 'Simple Questions',
              //       imageUrl:
              //           'https://cdn.satellite.earth/64b885412eb944828d964c21242f0c7415b1afbf4554eca08f9dd1afba0c7584.png',
              //       profileName: 'Niel Liesmons',
              //       profilePicUrl:
              //           'https://cdn.satellite.earth/946822b1ea72fd3710806c07420d6f7e7d4a7646b2002e6cc969bcf1feaa1009.png',
              //       timestamp: DateTime.now(),
              //       onTap: () {
              //         print('tapped');
              //       },
              //     );
              //   },
              //   onResolveProfile: (identifier) async {
              //     await Future.delayed(const Duration(seconds: 1));
              //     return await PartialProfile(
              //       npub: 'npub1337',
              //       name: 'Pip',
              //       pictureUrl: 'https://m.primal.net/IfSZ.jpg',
              //     ).signWith(DummySigner());
              //   },
              //   onResolveEmoji: (identifier) async {
              //     await Future.delayed(const Duration(seconds: 1));
              //     return 'https://cdn.satellite.earth/eb0122af34cf27ba7c8248d72294c32a956209f157aa9d697c7cdd6b054f9ea9.png';
              //   },
              //   onResolveHashtag: (identifier) async {
              //     await Future.delayed(const Duration(seconds: 1));
              //     return () {};
              //   },
              //   onLinkTap: (url) {
              //     print(url);
              //   },
              //   onReply: (nevent) {
              //     print(nevent);
              //   },
              //   zaps: [
              //     Zap(
              //       npub:
              //           'npub1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq',
              //       nevent:
              //           'nevent1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq',
              //       amount: 110,
              //       profileName: 'ثعبان',
              //       profilePicUrl:
              //           'https://cdn.satellite.earth/946822b1ea72fd3710806c07420d6f7e7d4a7646b2002e6cc969bcf1feaa1009.png',
              //       timestamp: DateTime.now(),
              //     ),
              //     Zap(
              //       npub:
              //           'npub1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq',
              //       nevent:
              //           'nevent1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq',
              //       amount: 56,
              //       profileName: 'Pip',
              //       profilePicUrl: 'https://m.primal.net/IfSZ.jpg',
              //       timestamp: DateTime.now(),
              //     ),
              //   ],
              //   reactions: [
              //     Reaction(
              //       npub:
              //           'npub1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq',
              //       nevent:
              //           'nevent1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq',
              //       emojiName: 'todo',
              //       emojiUrl:
              //           'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Femojiguide.org%2Fimages%2Femoji%2Fc%2F1e2fb481tsfvyc.png&f=1&nofb=1&ipt=73d8789f7a055e207ff06bd2278184a2ab6108a8c019f59d0526d05f91d925e7&ipo=images',
              //       profilePicUrl:
              //           'https://cdn.satellite.earth/da67840aae6720f5e5fb9e4c8ce25a85f6d8cbf22f4a04fd44babd58a9badfc6.png',
              //       profileName: "ثعبان",
              //       timestamp: DateTime.now(),
              //     ),
              //     Reaction(
              //       npub:
              //           'npub1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq',
              //       nevent:
              //           'nevent1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq',
              //       emojiName: 'todo',
              //       emojiUrl:
              //           'https://cdn.satellite.earth/60a5e73bfa6dfd35bd0b144f38f6ed2aaab0606b2bd68b623f419ae0709fa10a.png',
              //       profilePicUrl:
              //           'https://cdn.satellite.earth/946822b1ea72fd3710806c07420d6f7e7d4a7646b2002e6cc969bcf1feaa1009.png',
              //       profileName: "Niel Liesmons",
              //       timestamp: DateTime.now(),
              //     ),
              //   ],
              //   topReplies: [
              //     ReplyUserData(
              //       profileName: 'Zaplab',
              //       profilePicUrl:
              //           'https://cdn.satellite.earth/da67840aae6720f5e5fb9e4c8ce25a85f6d8cbf22f4a04fd44babd58a9badfc6.png',
              //     ),
              //     ReplyUserData(
              //       profileName: 'jrm',
              //       profilePicUrl:
              //           'https://pfp.nostr.build/e9e7963637e04d90ad2c33f21c6f112a188c5b001dd697e108991261487aa258.jpg',
              //     ),
              //     ReplyUserData(
              //       profileName: 'elsat',
              //       profilePicUrl:
              //           'https://image.nostr.build/ba781633731cd33bd20f58bbca208ae87db3f87c8f2256e23e4a8df543617c6c.png',
              //     ),
              //   ],
              //   totalReplies: 10,
              // ),
              // AppFeedPost(
              //   nevent: '1',
              //   content:
              //       'A new study on swipe actions shows that it cleans up interfaces like nothing else nostr:nevent123',
              //   profileName: 'Prof. Ille Namez',
              //   profilePicUrl:
              //       'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fmedia.licdn.com%2Fdms%2Fimage%2FD5603AQGo4xFyJdt9_Q%2Fprofile-displayphoto-shrink_200_200%2F0%2F1697162085116%3Fe%3D2147483647%26v%3Dbeta%26t%3DkrXTtbRXKpTPHLaTG72YYdPiy3JVHjv5naMeZ5pBhwc&f=1&nofb=1&ipt=76b21679ded9ac6d0ecd3f3520538c08d6a9433fee07170a53845c7b26068631&ipo=images',
              //   timestamp: DateTime.now(),
              //   onResolveEvent: (identifier) async {
              //     // Simulate network delay
              //     await Future.delayed(const Duration(seconds: 1));
              //     return NostrEvent(
              //       npub:
              //           'npub1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq',
              //       nevent:
              //           'nevent1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq',
              //       contentType: 'article',
              //       title: 'Swipe. Action.',
              //       imageUrl:
              //           'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fcitizenside.com%2Fwp-content%2Fuploads%2F2024%2F02%2Fnavigational-basics-swiping-actions-on-iphone-13-1707378213.jpg&f=1&nofb=1&ipt=ac222582df5c88d9e50ec5e74d3366dfd1fb9ac1b7c639fe74d525c5578d9117&ipo=images',
              //       profileName: 'N.U.X News',
              //       profilePicUrl:
              //           'https://cdn.satellite.earth/cbcd50ec769b65c03bc780f0b2d0967f893d10a29f7666d7df8f2d7614d493d4.png',
              //       timestamp: DateTime.now(),
              //       onTap: () {
              //         print('tapped');
              //       },
              //     );
              //   },
              //   onResolveProfile: (identifier) async {
              //     await Future.delayed(const Duration(seconds: 1));
              //     return await PartialProfile(
              //       npub: 'npub1337',
              //       name: 'Pip',
              //       pictureUrl: 'https://m.primal.net/IfSZ.jpg',
              //     ).signWith(DummySigner());
              //   },
              //   onResolveEmoji: (identifier) async {
              //     await Future.delayed(const Duration(seconds: 1));
              //     return 'https://cdn.satellite.earth/eb0122af34cf27ba7c8248d72294c32a956209f157aa9d697c7cdd6b054f9ea9.png';
              //   },
              //   onResolveHashtag: (identifier) async {
              //     await Future.delayed(const Duration(seconds: 1));
              //     return () {};
              //   },
              //   onLinkTap: (url) {
              //     print(url);
              //   },
              //   onReply: (nevent) {
              //     print(nevent);
              //   },
              //   zaps: [
              //     Zap(
              //       npub:
              //           'npub1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq',
              //       nevent:
              //           'nevent1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq',
              //       amount: 110,
              //       profileName: 'ثعبان',
              //       profilePicUrl:
              //           'https://cdn.satellite.earth/946822b1ea72fd3710806c07420d6f7e7d4a7646b2002e6cc969bcf1feaa1009.png',
              //       timestamp: DateTime.now(),
              //     ),
              //     Zap(
              //       npub:
              //           'npub1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq',
              //       nevent:
              //           'nevent1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq',
              //       amount: 56,
              //       profileName: 'Pip',
              //       profilePicUrl: 'https://m.primal.net/IfSZ.jpg',
              //       timestamp: DateTime.now(),
              //     ),
              //   ],
              //   reactions: [
              //     Reaction(
              //       npub:
              //           'npub1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq',
              //       nevent:
              //           'nevent1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq',
              //       emojiName: 'todo',
              //       emojiUrl:
              //           'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Femojiguide.org%2Fimages%2Femoji%2Fc%2F1e2fb481tsfvyc.png&f=1&nofb=1&ipt=73d8789f7a055e207ff06bd2278184a2ab6108a8c019f59d0526d05f91d925e7&ipo=images',
              //       profilePicUrl:
              //           'https://cdn.satellite.earth/da67840aae6720f5e5fb9e4c8ce25a85f6d8cbf22f4a04fd44babd58a9badfc6.png',
              //       profileName: "ثعبان",
              //       timestamp: DateTime.now(),
              //     ),
              //     Reaction(
              //       npub:
              //           'npub1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq',
              //       nevent:
              //           'nevent1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq',
              //       emojiName: 'todo',
              //       emojiUrl:
              //           'https://cdn.satellite.earth/60a5e73bfa6dfd35bd0b144f38f6ed2aaab0606b2bd68b623f419ae0709fa10a.png',
              //       profilePicUrl:
              //           'https://cdn.satellite.earth/946822b1ea72fd3710806c07420d6f7e7d4a7646b2002e6cc969bcf1feaa1009.png',
              //       profileName: "Niel Liesmons",
              //       timestamp: DateTime.now(),
              //     ),
              //   ],
              //   topReplies: [
              //     ReplyUserData(
              //       profileName: 'Zaplab',
              //       profilePicUrl:
              //           'https://cdn.satellite.earth/da67840aae6720f5e5fb9e4c8ce25a85f6d8cbf22f4a04fd44babd58a9badfc6.png',
              //     ),
              //     ReplyUserData(
              //       profileName: 'jrm',
              //       profilePicUrl:
              //           'https://pfp.nostr.build/e9e7963637e04d90ad2c33f21c6f112a188c5b001dd697e108991261487aa258.jpg',
              //     ),
              //     ReplyUserData(
              //       profileName: 'elsat',
              //       profilePicUrl:
              //           'https://image.nostr.build/ba781633731cd33bd20f58bbca208ae87db3f87c8f2256e23e4a8df543617c6c.png',
              //     ),
              //   ],
              //   totalReplies: 10,
              // ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => tabData(context).content;
}
