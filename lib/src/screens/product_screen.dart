import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/resolvers.dart';
import '../providers/history.dart';
import '../tabs/details/details.dart';
import 'package:go_router/go_router.dart';

class ProductScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductScreen({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen>
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
    ref.read(historyProvider.notifier).addEntry(widget.product);
    final recentHistory = ref.watch(recentHistoryItemsProvider(
        context, widget.product.id)); // Get latest 3 history entries

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
          LabProfilePic.s40(widget.product.author.value),
          const LabGap.s12(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LabGap.s2(),
                Row(
                  children: [
                    LabEmojiContentType(
                      contentType: getModelContentType(widget.product),
                      size: 16,
                    ),
                    const LabGap.s10(),
                    Expanded(
                      child: LabCompactTextRenderer(
                        model: widget.product,
                        isMedium: true,
                        isWhite: true,
                        content: getModelDisplayText(widget.product),
                        onResolveEvent: resolvers.eventResolver,
                        onResolveProfile: resolvers.profileResolver,
                        onResolveEmoji: resolvers.emojiResolver,
                      ),
                    ),
                  ],
                ),
                const LabGap.s2(),
                LabText.reg12(
                  widget.product.author.value?.name ??
                      formatNpub(widget.product.author.value?.npub ?? ''),
                  color: theme.colors.white66,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomBarContent: LabBottomBarProduct(
        product: widget.product,
        onAddLabelTap: (service) {},
        onMailTap: (service) {},
        onVoiceTap: (service) {},
        onActions: (service) {},
      ),
      child: Column(
        children: [
          LabProductHeader(
            product: widget.product,
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
                  content: const LabText.reg14('Labels content'),
                ),
                TabData(
                  label: 'Shares',
                  icon: LabIcon.s24(
                    theme.icons.characters.share,
                    outlineColor: theme.colors.white66,
                    outlineThickness: LabLineThicknessData.normal().medium,
                  ),
                  content: const LabText.reg14('Shares content'),
                ),
                TabData(
                  label: 'Details',
                  icon: LabIcon.s24(
                    theme.icons.characters.details,
                    outlineColor: theme.colors.white66,
                    outlineThickness: LabLineThicknessData.normal().medium,
                  ),
                  content: DetailsTab(model: widget.product),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
