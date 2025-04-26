import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/resolvers.dart';
import '../tabs/details/details.dart';

class PostScreen extends ConsumerStatefulWidget {
  final Note post;

  const PostScreen({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState<PostScreen>
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
    final resolvers = ref.read(resolversProvider);
    final state = ref.watch(query<Community>());
    final communities = state.models.cast<Community>().toList();

    return AppScreen(
      onHomeTap: () => Navigator.of(context).pop(),
      alwaysShowTopBar: false,
      topBarContent: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppProfilePic.s40(widget.post.author.value?.pictureUrl ?? ''),
          const AppGap.s12(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppGap.s2(),
                Row(
                  children: [
                    AppEmojiContentType(
                      contentType: getModelContentType(widget.post),
                      size: 16,
                    ),
                    const AppGap.s10(),
                    Expanded(
                      child: AppCompactTextRenderer(
                        isMedium: true,
                        isWhite: true,
                        content: getModelDisplayText(widget.post),
                        onResolveEvent: resolvers.eventResolver,
                        onResolveProfile: resolvers.profileResolver,
                        onResolveEmoji: resolvers.emojiResolver,
                      ),
                    ),
                  ],
                ),
                const AppGap.s2(),
                AppText.reg12(
                  widget.post.author.value?.name ??
                      formatNpub(widget.post.author.value?.npub ?? ''),
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
            AppPost(
              post: widget.post,
              communities: communities,
              onResolveEvent: resolvers.eventResolver,
              onResolveProfile: resolvers.profileResolver,
              onResolveEmoji: resolvers.emojiResolver,
              onResolveHashtag: resolvers.hashtagResolver,
              onLinkTap: (url) {
                print(url);
              },
            ),
            AppContainer(
              child: AppTabView(
                controller: _tabController,
                tabs: [
                  TabData(
                    label: 'Replies',
                    icon: AppIcon.s20(
                      theme.icons.characters.reply,
                      outlineColor: theme.colors.white66,
                      outlineThickness: LineThicknessData.normal().medium,
                    ),
                    content: const AppLoadingFeed(
                      type: LoadingFeedType.post,
                    ),
                  ),
                  TabData(
                    label: 'Shares',
                    icon: AppIcon.s20(
                      theme.icons.characters.share,
                      outlineColor: theme.colors.white66,
                      outlineThickness: LineThicknessData.normal().medium,
                    ),
                    content: const AppText.reg14('Shares content'),
                  ),
                  TabData(
                    label: 'Labels',
                    icon: AppIcon.s20(
                      theme.icons.characters.label,
                      outlineColor: theme.colors.white66,
                      outlineThickness: LineThicknessData.normal().medium,
                    ),
                    content: const AppText.reg14('Labels content'),
                  ),
                  TabData(
                    label: 'Details',
                    icon: AppIcon.s20(
                      theme.icons.characters.info,
                      outlineColor: theme.colors.white66,
                      outlineThickness: LineThicknessData.normal().medium,
                    ),
                    content: DetailsTab(model: widget.post),
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
