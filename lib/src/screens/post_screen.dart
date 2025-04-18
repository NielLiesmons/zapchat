import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/resolvers.dart';

class PostScreen extends ConsumerWidget {
  final Note post;

  const PostScreen({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final resolvers = ref.read(resolversProvider);
    final state = ref.watch(queryType<Community>());
    final communities = state.models.cast<Community>().toList();

    return AppScreen(
      onHomeTap: () => Navigator.of(context).pop(),
      alwaysShowTopBar: false,
      topBarContent: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppProfilePic.s40(post.author.value?.pictureUrl ?? ''),
          const AppGap.s12(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppGap.s8(),
                Row(
                  children: [
                    AppEmojiContentType(
                      contentType: getEventContentType(post),
                      size: 16,
                    ),
                    const AppGap.s10(),
                    Expanded(
                      child: AppCompactTextRenderer(
                        isMedium: true,
                        isWhite: true,
                        content: getEventDisplayText(post),
                        onResolveEvent: resolvers.eventResolver,
                        onResolveProfile: resolvers.profileResolver,
                        onResolveEmoji: resolvers.emojiResolver,
                      ),
                    ),
                  ],
                ),
                const AppGap.s2(),
                AppText.reg12(
                  post.author.value?.name ??
                      formatNpub(post.author.value?.npub ?? ''),
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
              post: post,
              communities: communities,
              onResolveEvent: resolvers.eventResolver,
              onResolveProfile: resolvers.profileResolver,
              onResolveEmoji: resolvers.emojiResolver,
              onResolveHashtag: resolvers.hashtagResolver,
              onLinkTap: (url) {
                print(url);
              },
            ),
            Expanded(
              child: AppTabView(
                controller: AppTabController(length: 4),
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
                    content: const AppText.reg14('Details content'),
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
