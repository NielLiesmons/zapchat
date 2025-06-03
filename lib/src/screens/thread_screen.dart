import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/resolvers.dart';
import '../providers/history.dart';
import '../tabs/details/details.dart';

class ThreadScreen extends ConsumerStatefulWidget {
  final Note thread;

  const ThreadScreen({
    super.key,
    required this.thread,
  });

  @override
  ConsumerState<ThreadScreen> createState() => _ThreadScreenState();
}

class _ThreadScreenState extends ConsumerState<ThreadScreen>
    with SingleTickerProviderStateMixin {
  late AppTabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = AppTabController(length: 4);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    // Record in history
    ref.read(historyProvider.notifier).addEntry(widget.thread);
    final recentHistory = ref.watch(recentHistoryItemsProvider(
        context, widget.thread.id)); // Get latest 3 history entries

    // Get data
    final resolvers = ref.read(resolversProvider);
    final state = ref.watch(query<Community>());
    final communities = state.models.cast<Community>().toList();

    return AppScreen(
      history: recentHistory,
      onHomeTap: () => Navigator.of(context).pop(),
      alwaysShowTopBar: false,
      topBarContent: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppProfilePic.s40(widget.thread.author.value),
          const AppGap.s12(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppGap.s2(),
                Row(
                  children: [
                    AppEmojiContentType(
                      contentType: getModelContentType(widget.thread),
                      size: 16,
                    ),
                    const AppGap.s10(),
                    Expanded(
                      child: AppCompactTextRenderer(
                        isMedium: true,
                        isWhite: true,
                        content: getModelDisplayText(widget.thread),
                        onResolveEvent: resolvers.eventResolver,
                        onResolveProfile: resolvers.profileResolver,
                        onResolveEmoji: resolvers.emojiResolver,
                      ),
                    ),
                  ],
                ),
                const AppGap.s2(),
                AppText.reg12(
                  widget.thread.author.value?.name ??
                      formatNpub(widget.thread.author.value?.npub ?? ''),
                  color: theme.colors.white66,
                ),
              ],
            ),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Column(
          children: [
            AppThread(
              thread: widget.thread,
              communities: communities,
              onResolveEvent: resolvers.eventResolver,
              onResolveProfile: resolvers.profileResolver,
              onResolveEmoji: resolvers.emojiResolver,
              onResolveHashtag: resolvers.hashtagResolver,
              onLinkTap: (url) {
                print(url);
              },
              onProfileTap: (profile) =>
                  context.push('/profile/${profile.npub}', extra: profile),
            ),
            AppContainer(
              child: AppTabView(
                controller: _tabController,
                tabs: [
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
                      theme.icons.characters.info,
                      outlineColor: theme.colors.white66,
                      outlineThickness: AppLineThicknessData.normal().medium,
                    ),
                    content: DetailsTab(model: widget.thread),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
