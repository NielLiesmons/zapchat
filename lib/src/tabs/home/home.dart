import 'package:zaplab_design/zaplab_design.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/resolvers.dart';

class HomeTab extends ConsumerStatefulWidget {
  final String? activePubkey;
  const HomeTab({super.key, this.activePubkey});

  static TabData tabData(BuildContext context, {String? activePubkey}) {
    final theme = LabTheme.of(context);

    return TabData(
      label: 'Home',
      icon: LabIcon.s32(
        theme.icons.characters.home,
        gradient: theme.colors.graydient66,
      ),
      bottomBar: LabPlatformUtils.isMobile
          ? LabBottomBarHome(
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
            )
          : null,
      content: HomeTab(activePubkey: activePubkey),
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

    return _buildHomeContent();
  }

  Widget _buildHomeContent() {
    final theme = LabTheme.of(context);
    final resolvers = ref.read(resolversProvider);

    final communitiesState = ref.watch(
      query<Community>(
        authors: {
          Utils.decodeShareableToString(
            'npub1pr28pamqhcfacyqudjrfyyfzhjwgz3xxfc85yjp42396he30ztls42rfw8',
          ),
          // Utils.decodeShareableToString(
          //   'npub1w5d4ws7d607qwszk4nwm3ugkzkzvvge8mmv0jxfk7edthfnlqhrs8n72uv',
          // ),
          Utils.decodeShareableToString(
            'npub18stt78efprta2el02tzgnez6ehghzgtt000v58967wvkgezjmprs0n7h7u',
          ),
          Utils.decodeShareableToString(
            'npub1vcxcc7r9racyslkfhrwu9qlznne9v95nmk3m5frd8lfuprdmwzpsxqzqcr',
          ),
          Utils.decodeShareableToString(
            'npub1229y50ruvq9hjdxsjknh43gq4n9ef7h3h5hc4ezzrkg0q7kgg0tsv9a402',
          ),
        },
        and: (c) => {
          c.author,
          c.chatMessages,
        }, // Load relationships like in working example
        source: LocalAndRemoteSource(stream: true, background: true),
        limit: 5, // Just start with 5 communities like the test app
      ),
    );

    // Debug logging
    print('🏠 Communities query state: $communitiesState');
    if (communitiesState is StorageData) {
      print('🏠 Found ${communitiesState.models.length} communities');
      for (final community in communitiesState.models) {
        print(
            '🏠 Community: ${community.event.pubkey} - ${community.event.content}');
      }
    } else if (communitiesState is StorageError) {
      print('🏠 Communities query error');
    }

    return switch (communitiesState) {
      StorageLoading() => const LabLoadingFeed(),
      StorageError(:final exception) => LabText.med14('Error: $exception'),
      StorageData(:final models) => models.isEmpty
          ? const LabText.med14('No communities found')
          : Column(
              children: [
                for (final community in models)
                  LabCommunityHomePanel(
                    community: community,
                    lastModel: community.chatMessages.toList().firstOrNull,
                    mainCount: 0,
                    contentCounts: {
                      'chat': community.chatMessages.length,
                    },
                    onNavigateToCommunity: (community) {
                      context
                          .push('/community/${community.event.pubkey}', extra: {
                        'community': community,
                        'activePubkey': widget.activePubkey,
                      });
                    },
                    onNavigateToContent: (community, contentType) {
                      context.push(
                          '/community/${community.event.pubkey}/$contentType',
                          extra: {
                            'community': community,
                            'activePubkey': widget.activePubkey,
                          });
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
                    activePubkey: widget.activePubkey,
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
            ),
    };
  }
}
