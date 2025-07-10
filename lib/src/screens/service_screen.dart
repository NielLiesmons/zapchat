import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/resolvers.dart';
import '../providers/history.dart';
import '../tabs/details/details.dart';
import 'package:go_router/go_router.dart';

class ServiceScreen extends ConsumerStatefulWidget {
  final Service service;

  const ServiceScreen({
    super.key,
    required this.service,
  });

  @override
  ConsumerState<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends ConsumerState<ServiceScreen>
    with SingleTickerProviderStateMixin {
  late LabTabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = LabTabController(length: 5);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    // History
    ref.read(historyProvider.notifier).addEntry(widget.service);
    final recentHistory = ref.watch(recentHistoryItemsProvider(
        context, widget.service.id)); // Get latest 3 history entries

    // Get Data
    final resolvers = ref.read(resolversProvider);
    final state = ref.watch(query<Community>());
    final communities = state.models.cast<Community>().toList();

    return LabScreen(
      onHomeTap: () => context.push('/'),
      alwaysShowTopBar: false,
      history: recentHistory,
      topBarContent: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LabProfilePic.s40(widget.service.author.value),
          const LabGap.s12(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LabGap.s2(),
                Row(
                  children: [
                    LabEmojiContentType(
                      contentType: getModelContentType(widget.service),
                      size: 16,
                    ),
                    const LabGap.s10(),
                    Expanded(
                      child: LabCompactTextRenderer(
                        model: widget.service,
                        isMedium: true,
                        isWhite: true,
                        content: getModelDisplayText(widget.service),
                        onResolveEvent: resolvers.eventResolver,
                        onResolveProfile: resolvers.profileResolver,
                        onResolveEmoji: resolvers.emojiResolver,
                      ),
                    ),
                  ],
                ),
                const LabGap.s2(),
                LabText.reg12(
                  widget.service.author.value?.name ??
                      formatNpub(widget.service.author.value?.npub ?? ''),
                  color: theme.colors.white66,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomBarContent: LabBottomBarService(
        service: widget.service,
        onAddLabelTap: (service) {},
        onMailTap: (service) {},
        onVoiceTap: (service) {},
        onActions: (service) {},
      ),
      child: Column(
        children: [
          LabServiceHeader(
            service: widget.service,
            communities: communities,
            onProfileTap: (profile) => context.push(
              '/profile/${profile.npub}',
              extra: profile,
            ),
          ),
          LabContainer(
            child: LabTabView(
              controller: _tabController,
              tabs: [
                TabData(
                  label: 'Service',
                  icon: LabEmojiContentType(
                    contentType: getModelContentType(widget.service),
                    size: 24,
                  ),
                  content: LabContainer(
                    padding: const LabEdgeInsets.symmetric(
                      vertical: LabGapSize.s10,
                      horizontal: LabGapSize.s12,
                    ),
                    child: LabShortTextRenderer(
                      model: widget.service,
                      content: widget.service.content,
                      onResolveEvent: resolvers.eventResolver,
                      onResolveProfile: resolvers.profileResolver,
                      onResolveEmoji: resolvers.emojiResolver,
                      onResolveHashtag: resolvers.hashtagResolver,
                      onLinkTap: (url) {},
                      onProfileTap: (profile) => context
                          .push('/profile/${profile.npub}', extra: profile),
                    ),
                  ),
                ),
                TabData(
                  label: 'Replies',
                  icon: LabIcon.s24(
                    theme.icons.characters.reply,
                    outlineColor: theme.colors.white66,
                    outlineThickness: LabLineThicknessData.normal().medium,
                  ),
                  content: const LabLoadingFeed(
                    type: LoadingFeedType.thread,
                  ),
                ),
                TabData(
                  label: 'Labels',
                  icon: LabIcon.s24(
                    theme.icons.characters.label,
                    outlineColor: theme.colors.white66,
                    outlineThickness: LabLineThicknessData.normal().medium,
                  ),
                  content: const LabLoadingFeed(),
                ),
                TabData(
                  label: 'Shares',
                  icon: LabIcon.s24(
                    theme.icons.characters.share,
                    outlineColor: theme.colors.white66,
                    outlineThickness: LabLineThicknessData.normal().medium,
                  ),
                  content: const LabLoadingFeed(),
                ),
                TabData(
                  label: 'Details',
                  icon: LabIcon.s24(
                    theme.icons.characters.details,
                    outlineColor: theme.colors.white66,
                    outlineThickness: LabLineThicknessData.normal().medium,
                  ),
                  content: DetailsTab(model: widget.service),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
