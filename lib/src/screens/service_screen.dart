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
  late AppTabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = AppTabController(length: 5);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    // History
    ref.read(historyProvider.notifier).addEntry(widget.service);
    final recentHistory = ref.watch(recentHistoryItemsProvider(
        context, widget.service.id)); // Get latest 3 history entries

    // Get Data
    final resolvers = ref.read(resolversProvider);
    // final state = ref.watch(query<Service>());
    // final services = state.models.cast<Service>().toList();

    return AppScreen(
      onHomeTap: () => context.push('/'),
      alwaysShowTopBar: false,
      history: recentHistory,
      topBarContent: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppProfilePic.s40(widget.service.author.value),
          const AppGap.s12(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppGap.s2(),
                Row(
                  children: [
                    AppEmojiContentType(
                      contentType: getModelContentType(widget.service),
                      size: 16,
                    ),
                    const AppGap.s10(),
                    Expanded(
                      child: AppCompactTextRenderer(
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
                const AppGap.s2(),
                AppText.reg12(
                  widget.service.author.value?.name ??
                      formatNpub(widget.service.author.value?.npub ?? ''),
                  color: theme.colors.white66,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomBarContent: AppBottomBarService(
        service: widget.service,
        onAddLabelTap: (service) {},
        onMailTap: (service) {},
        onVoiceTap: (service) {},
        onActions: (service) {},
      ),
      child: Column(
        children: [
          AppServiceHeader(
            service: widget.service,
            communities: [],
            onProfileTap: (profile) => context.push(
              '/profile/${profile.npub}',
              extra: profile,
            ),
          ),
          AppContainer(
            child: AppTabView(
              controller: _tabController,
              tabs: [
                TabData(
                  label: 'Service',
                  icon: AppEmojiContentType(
                    contentType: getModelContentType(widget.service),
                    size: 24,
                  ),
                  content: AppContainer(
                    padding: const AppEdgeInsets.symmetric(
                      vertical: AppGapSize.s10,
                      horizontal: AppGapSize.s12,
                    ),
                    child: AppShortTextRenderer(
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
                  icon: AppIcon.s24(
                    theme.icons.characters.reply,
                    outlineColor: theme.colors.white66,
                    outlineThickness: AppLineThicknessData.normal().medium,
                  ),
                  content: const AppLoadingFeed(
                    type: LoadingFeedType.thread,
                  ),
                ),
                TabData(
                  label: 'Shares',
                  icon: AppIcon.s24(
                    theme.icons.characters.share,
                    outlineColor: theme.colors.white66,
                    outlineThickness: AppLineThicknessData.normal().medium,
                  ),
                  content: const AppText.reg14('Shares content'),
                ),
                TabData(
                  label: 'Labels',
                  icon: AppIcon.s24(
                    theme.icons.characters.label,
                    outlineColor: theme.colors.white66,
                    outlineThickness: AppLineThicknessData.normal().medium,
                  ),
                  content: const AppText.reg14('Labels content'),
                ),
                TabData(
                  label: 'Details',
                  icon: AppIcon.s24(
                    theme.icons.characters.details,
                    outlineColor: theme.colors.white66,
                    outlineThickness: AppLineThicknessData.normal().medium,
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
