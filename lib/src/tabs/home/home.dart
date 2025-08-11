import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';
import '../../providers/resolvers.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  TabData tabData(BuildContext context) {
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
      content: HookConsumer(
        builder: (context, ref, _) {
          final resolvers = ref.read(resolversProvider);

          // Specific community authors to show on home page (npubs will be decoded to hex)
          final communityAuthors = {
            Utils.decodeShareableToString(
                'npub1pr28pamqhcfacyqudjrfyyfzhjwgz3xxfc85yjp42396he30ztls42rfw8'), // Replace with actual npub
            Utils.decodeShareableToString(
                'npub1w5d4ws7d607qwszk4nwm3ugkzkzvvge8mmv0jxfk7edthfnlqhrs8n72uv'),
            Utils.decodeShareableToString(
                'npub18stt78efprta2el02tzgnez6ehghzgtt000v58967wvkgezjmprs0n7h7u'), // Replace with actual npub
            Utils.decodeShareableToString(
                'npub1vcxcc7r9racyslkfhrwu9qlznne9v95nmk3m5frd8lfuprdmwzpsxqzqcr'), // Replace with actual npub
          };

          // Show cached data immediately, then sync in background
          final state = ref.watch(query<Community>(
            authors: communityAuthors,
            and: (c) => {c.author, c.chatMessages},
            source: LocalAndRemoteSource(
                background: true), // Local first, remote in background
          ));

          final communities = state.models;

          return Column(
            children: [
              for (final community in communities)
                LabCommunityHomePanel(
                  community: community,
                  lastModel: community.chatMessages.toList().firstOrNull,
                  mainCount: 2,
                  contentCounts: {
                    'chat': 10,
                  },
                  onNavigateToCommunity: (community) {
                    context.push('/simple-chat-test', extra: community);
                  },
                  onNavigateToContent: (community, contentType) {
                    context.push('/simple-chat-test', extra: community);
                  },
                  onNavigateToNotifications: (community) {
                    context.push('/simple-chat-test', extra: community);
                  },
                  onResolveEvent: resolvers.eventResolver,
                  onResolveProfile: resolvers.profileResolver,
                  onResolveEmoji: resolvers.emojiResolver,
                  onCreateNewPublication: (community) {
                    context.push('/create/', extra: community);
                  },
                ),
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
                            outlineThickness:
                                LabLineThicknessData.normal().thick,
                            outlineColor: theme.colors.white33,
                          ),
                        ),
                      ),
                      const LabGap.s12(),
                      LabText.med14('Add a Community',
                          color: theme.colors.white33),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
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
  Widget build(BuildContext context) => tabData(context).content;
}
