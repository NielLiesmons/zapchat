import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';
import '../../providers/resolvers.dart';

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
      bottomBar: HookConsumer(
        builder: (context, ref, _) {
          final activeProfile = ref.watch(Signer.activeProfileProvider);
          return AppBottomBarHome(
            onZapTap: activeProfile != null
                ? () {
                    context.push('/pay');
                  }
                : null,
            onAddTap: () {
              context.push('/create/');
            },
            onSearchTap: () {
              context.push('/search/');
            },
            onActions: () {
              context.push('/actions/home');
            },
          );
        },
      ),
      content: HookConsumer(
        builder: (context, ref, _) {
          final resolvers = ref.read(resolversProvider);
          final state = ref.watch(query<Community>());
          final state2 = ref.watch(query<Group>());
          final activeProfile = ref.watch(Signer.activeProfileProvider);

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

          return Column(
            children: [
              for (final community in communities
                  .where((c) => activeProfile != null || c.name == 'Zapchat'))
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
                  onResolveEvent: resolvers.eventResolver,
                  onResolveProfile: resolvers.profileResolver,
                  onResolveEmoji: resolvers.emojiResolver,
                  onCreateNewPublication: (community) {
                    context.push('/create/', extra: community);
                  },
                ),
              if (activeProfile != null) ...[
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
                    onResolveEvent: resolvers.eventResolver,
                    onResolveProfile: resolvers.profileResolver,
                    onResolveEmoji: resolvers.emojiResolver,
                    onCreateNewPublication: (community) {
                      context.push('/create/', extra: community);
                    },
                  ),
              ],
              AppContainer(
                padding: AppEdgeInsets.all(AppGapSize.s12),
                height: 1000,
                child: AppPanelButton(
                  color: theme.colors.gray33,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppContainer(
                        width: theme.sizes.s48,
                        height: theme.sizes.s48,
                        decoration: BoxDecoration(
                          color: theme.colors.white8,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: AppIcon.s20(
                            theme.icons.characters.plus,
                            outlineThickness:
                                AppLineThicknessData.normal().thick,
                            outlineColor: theme.colors.white33,
                          ),
                        ),
                      ),
                      const AppGap.s12(),
                      AppText.med14('Add a Community',
                          color: theme.colors.white33),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      settingsDescription: "Filter your groups and communities",
      settingsContent: AppContainer(
        child: Column(
          children: [
            AppSectionTitle("Filter"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => tabData(context).content;
}
