import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/resolvers.dart';
import '../providers/history.dart';
import '../tabs/details/details.dart';
import 'package:go_router/go_router.dart';

class ArticleScreen extends ConsumerStatefulWidget {
  final Article article;

  const ArticleScreen({
    super.key,
    required this.article,
  });

  @override
  ConsumerState<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends ConsumerState<ArticleScreen>
    with SingleTickerProviderStateMixin {
  late LabTabController _tabController;
  late ScrollController _scrollController;
  double _scrollProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = LabTabController(length: 5);
    _scrollController = ScrollController();
    _scrollController.addListener(_updateScrollProgress);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.removeListener(_updateScrollProgress);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateScrollProgress() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      final progress = maxScroll > 0 ? currentScroll / maxScroll : 0.0;
      setState(() => _scrollProgress = progress);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    // History
    ref.read(historyProvider.notifier).addEntry(widget.article);
    final recentHistory = ref.watch(recentHistoryItemsProvider(
        context, widget.article.id)); // Get latest 3 history entries

    // Get Data
    final resolvers = ref.read(resolversProvider);
    final state = ref.watch(query<Community>());
    final communities = state.models.cast<Community>().toList();

    return LabScreen(
      onHomeTap: () => context.push('/'),
      history: recentHistory,
      scrollController: _scrollController,
      topBarContent: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LabProfilePic.s40(widget.article.author.value),
          const LabGap.s12(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LabGap.s8(),
                Row(
                  children: [
                    LabEmojiContentType(
                      contentType: getModelContentType(widget.article),
                      size: 16,
                    ),
                    const LabGap.s10(),
                    Expanded(
                      child: LabCompactTextRenderer(
                        model: widget.article,
                        isMedium: true,
                        isWhite: true,
                        content: getModelDisplayText(widget.article),
                        onResolveEvent: resolvers.eventResolver,
                        onResolveProfile: resolvers.profileResolver,
                        onResolveEmoji: resolvers.emojiResolver,
                      ),
                    ),
                  ],
                ),
                const LabGap.s2(),
                LabContainer(
                  padding: const LabEdgeInsets.symmetric(
                    vertical: LabGapSize.s4,
                  ),
                  child: LabProgressBar(
                    progress: _scrollProgress,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomBarContent: LabBottomBarLongText(
        model: widget.article,
        onZapTap: (model) {},
        onPlayTap: (model) {},
        onReplyTap: (model) {},
        onVoiceTap: (model) {},
        onActions: (model) {},
      ),
      child: Column(
        children: [
          LabArticleHeader(
            article: widget.article,
            communities: communities,
            onProfileTap: (profile) =>
                context.push('/profile/${profile.npub}', extra: profile),
          ),
          LabContainer(
            child: LabTabView(
              controller: _tabController,
              tabs: [
                TabData(
                  label: 'Article',
                  icon: LabEmojiContentType(
                    contentType: getModelContentType(widget.article),
                    size: 24,
                  ),
                  content: LabContainer(
                    padding: const LabEdgeInsets.symmetric(
                      vertical: LabGapSize.s10,
                      horizontal: LabGapSize.s16,
                    ),
                    child: LabLongTextRenderer(
                      model: widget.article,
                      language: "ndown",
                      content: widget.article.content,
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
                  content: DetailsTab(model: widget.article),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
