import 'package:go_router/go_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

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
          final state2 = ref.watch(query<Group>());

          final communities = state.models.cast<Community>();
          final groups = state2.models.cast<Group>();

          final chatMessages =
              ref.watch(query<ChatMessage>()).models.cast<ChatMessage>();

          final communityCounts = {
            'Zapchat': {'main': 20, 'Chat': 15, 'Tasks': 3},
            'Cypher Chads': {'main': 4, 'Chat': 12, 'Threads': 15},
            'Communikeys': {'main': 3, 'Chat': 18, 'Threads': 9},
            'Nips Out': {'main': 1, 'Chat': 10, 'Wikis': 8},
            'Metabolism Go Up': {'Threads': 12, 'Work-outs': 1},
          };

          final groupCounts = {
            'The Gang': {
              'main': 0,
              'Chat': 15,
              'Albums': 2,
            },
          };

          return Column(
            children: [
              for (final community in communities)
                AppCommunityHomePanel(
                  community: community,
                  lastModel:
                      chatMessages.isNotEmpty ? chatMessages.first : null,
                  mainCount: communityCounts[community.name]?['main'] ?? 0,
                  contentCounts: {
                    'chat': communityCounts[community.name]?['Chat'] ?? 0,
                    'thread': communityCounts[community.name]?['Threads'] ?? 0,
                    'article':
                        communityCounts[community.name]?['Articles'] ?? 0,
                    'app': communityCounts[community.name]?['Apps'] ?? 0,
                    'book': communityCounts[community.name]?['Books'] ?? 0,
                    'task': communityCounts[community.name]?['Tasks'] ?? 0,
                    'wiki': communityCounts[community.name]?['Wikis'] ?? 0,
                    'work-out':
                        communityCounts[community.name]?['Work-outs'] ?? 0,
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
              for (final group in groups)
                AppGroupHomePanel(
                  group: group,
                  lastModel:
                      chatMessages.isNotEmpty ? chatMessages.first : null,
                  mainCount: 0,
                  contentCounts: {
                    'chat': 8,
                    'album': 2,
                  },
                  onNavigateToGroup: (group) {
                    context.push(
                      '/group/${group.author.value?.npub}/chat',
                      extra: group,
                    );
                  },
                  onNavigateToContent: (community, contentType) {
                    context.push(
                      '/group/${group.author.value?.npub}/$contentType',
                      extra: group,
                    );
                  },
                  onNavigateToNotifications: (group) {
                    context.push(
                      '/group/${group.author.value?.npub}/notifications',
                      extra: group,
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
