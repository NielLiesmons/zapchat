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
      label: 'Home',
      icon: AppIcon.s32(
        theme.icons.characters.home,
        gradient: theme.colors.graydient66,
      ),
      content: HookConsumer(
        builder: (context, ref, _) {
          final state = ref.watch(query<Community>());

          final communities = state.models.cast<Community>();

          final chatMessages =
              ref.watch(query<ChatMessage>()).models.cast<ChatMessage>();

          return Column(
            children: [
              for (final community in communities)
                AppCommunityHomePanel(
                  community: community,
                  lastModel:
                      chatMessages.isNotEmpty ? chatMessages.first : null,
                  mainCount: 21,
                  contentCounts: {
                    'chat': 8,
                    'thread': 6,
                    'article': 4,
                  },
                  onNavigateToCommunity: (community) {
                    context.push(
                      '/community/${community.author.value?.npub}/chat',
                      extra: community,
                    );
                  },
                  onNavigateToContent: (community, contentType) {
                    context.push(
                      '/community/${community.author.value?.npub}/$contentType',
                      extra: community,
                    );
                  },
                  onNavigateToNotifications: (community) {
                    context.push(
                      '/community/${community.author.value?.npub}/notifications',
                      extra: community,
                    );
                  },
                  onResolveEvent: (nevent) async {
                    // Simulate network delay
                    await Future.delayed(const Duration(seconds: 1));
                    final thread = await PartialNote(
                      'Test thread content',
                      createdAt: DateTime.now(),
                    ).dummySign();
                    await ref
                        .read(storageNotifierProvider.notifier)
                        .save({thread});
                    return (model: thread, onTap: null);
                  },
                  onResolveProfile: (npub) async {
                    await Future.delayed(const Duration(seconds: 1));
                    return (
                      profile: await PartialProfile(
                        name: 'Pip',
                        pictureUrl: 'https://m.primal.net/IfSZ.jpg',
                      ).dummySign(),
                      onTap: null,
                    );
                  },
                  onResolveEmoji: (identifier) async {
                    await Future.delayed(const Duration(seconds: 1));
                    return 'https://cdn.satellite.earth/eb0122af34cf27ba7c8248d72294c32a956209f157aa9d697c7cdd6b054f9ea9.png';
                  },
                  onCreateNewPublication: (community) {
                    context.push('/create/', extra: community);
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
