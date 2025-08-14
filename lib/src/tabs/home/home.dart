import 'package:zaplab_design/zaplab_design.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:models/models.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../providers/resolvers.dart';
import '../../providers/communities_provider.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  static TabData tabData(BuildContext context) {
    final theme = LabTheme.of(context);

    return TabData(
      label: 'Home',
      icon: LabIcon.s32(
        theme.icons.characters.home,
        gradient: theme.colors.graydient66,
      ),
      bottomBar: LabPlatformUtils.isMobile
          ? HookConsumer(
              builder: (context, ref, _) {
                final activePubkey = ref.watch(Signer.activePubkeyProvider);
                return LabBottomBarHome(
                  onZapTap: activePubkey != null
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
            )
          : null,
      content: const HomeTab(),
      optionsDescription: "Filter your groups and communities",
      optionssContent: LabContainer(
        child: Column(
          children: [
            LabSectionTitle("Filter"),
          ],
        ),
      ),
    );
  }

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  @override
  void initState() {
    super.initState();
    print('🏠 Home tab initialized');
  }

  @override
  void dispose() {
    print('🏠 Home tab disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('🏠 Home tab building');

    final theme = LabTheme.of(context);
    final resolvers = ref.read(resolversProvider);

    // Use the centralized communities provider
    final communitiesState = ref.watch(communitiesProvider);

    print(
        '🏠 Home tab using centralized provider - Communities: ${communitiesState.communities.length}, Messages: ${communitiesState.communityMessages.length}');

    return Column(
      children: [
        for (final community in communitiesState.communities)
          LabCommunityHomePanel(
            community: community,
            lastModel: ref
                .read(communitiesProvider.notifier)
                .getLatestCommunityMessage(community.id),
            mainCount: 2,
            contentCounts: {
              'chat': ref
                  .read(communitiesProvider.notifier)
                  .getCommunityMessages(community.id)
                  .length,
            },
            onNavigateToCommunity: (community) {
              context.push('/community/${community.event.pubkey}',
                  extra: community);
            },
            onNavigateToContent: (community, contentType) {
              context.push('/community/${community.event.pubkey}/$contentType',
                  extra: community);
            },
            onNavigateToNotifications: (community) {
              context.push(
                  '/community/${community.author.value?.pubkey}/notifications',
                  extra: community);
            },
            onResolveEvent: resolvers.eventResolver,
            onResolveProfile: resolvers.profileResolver,
            onResolveEmoji: resolvers.emojiResolver,
            onCreateNewPublication: (community) {
              context.push('/create/', extra: community);
            },
          ),
        // Keep the "Add a Community" button
        LabContainer(
          padding: LabEdgeInsets.all(LabGapSize.s12),
          height: 1000,
          child: LabPanelButton(
            color: theme.colors.gray33,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LabContainer(
                  width: theme.sizes.s48,
                  height: theme.sizes.s48,
                  decoration: BoxDecoration(
                    color: theme.colors.white8,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: LabIcon.s20(
                      theme.icons.characters.plus,
                      outlineThickness: LabLineThicknessData.normal().thick,
                      outlineColor: theme.colors.white33,
                    ),
                  ),
                ),
                const LabGap.s12(),
                LabText.med14('Add a Community', color: theme.colors.white33),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
