import 'package:go_router/go_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';

class ChatTab extends StatelessWidget {
  const ChatTab({super.key});

  TabData tabData(BuildContext context) {
    final theme = AppTheme.of(context);

    return TabData(
      label: 'Chats',
      icon: const AppEmojiContentType(contentType: 'chat'),
      content: HookConsumer(
        builder: (context, ref, _) {
          final state = ref.watch(query<Community>());

          final communities = state.models.cast<Community>();

          return Column(
            children: [
              for (final community in communities)
                AppCommunityHomePanel(
                  community: community,
                  mainCount: 5,
                  contentCounts: {
                    'chat': 2,
                    'post': 2,
                    'article': 1,
                  },
                  onNavigateToChat: (community) {
                    context.push(
                      '/community/${community.author.value?.pubkey}',
                      extra: community,
                    );
                  },
                  onNavigateToContent: (community, contentType) {
                    context.push(
                        '/content/${community.author.value?.pubkey}/$contentType');
                  },
                  onResolveEvent: (nevent) async {
                    // Simulate network delay
                    await Future.delayed(const Duration(seconds: 1));
                    final post = await PartialNote(
                      'Test post content',
                      createdAt: DateTime.now(),
                    ).signWith(DummySigner(),
                        withPubkey:
                            'a9434ee165ed01b286becfc2771ef1705d3537d051b387288898cc00d5c885be');
                    await ref
                        .read(storageNotifierProvider.notifier)
                        .save({post});
                    return (event: post, onTap: null);
                  },
                  onResolveProfile: (npub) async {
                    await Future.delayed(const Duration(seconds: 1));
                    return (
                      profile: await PartialProfile(
                        name: 'Pip',
                        pictureUrl: 'https://m.primal.net/IfSZ.jpg',
                      ).signWith(DummySigner()),
                      onTap: null
                    );
                  },
                  onResolveEmoji: (identifier) async {
                    await Future.delayed(const Duration(seconds: 1));
                    return 'https://cdn.satellite.earth/eb0122af34cf27ba7c8248d72294c32a956209f157aa9d697c7cdd6b054f9ea9.png';
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
