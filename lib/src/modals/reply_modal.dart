import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
import '../providers/resolvers.dart';
import '../tabs/details/details.dart';

class ReplyModal extends ConsumerStatefulWidget {
  final Comment reply;

  const ReplyModal({
    super.key,
    required this.reply,
  });

  @override
  ConsumerState<ReplyModal> createState() => _ReplyModalState();
}

class _ReplyModalState extends ConsumerState<ReplyModal>
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
    final repliesState = ref.watch(query<Comment>(
      where: (comment) => comment.parentModel.value?.id == widget.reply.id,
    ));
    final replies = repliesState.models.cast<Comment>().toList();

    return AppModal(
      includePadding: false,
      topBar: AppContainer(
        padding: const AppEdgeInsets.all(AppGapSize.s12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppProfilePic.s40(widget.reply.author.value),
            const AppGap.s12(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppGap.s2(),
                  Row(
                    children: [
                      AppEmojiContentType(
                        contentType: getModelContentType(widget.reply),
                        size: 16,
                      ),
                      const AppGap.s10(),
                      Expanded(
                        child: AppCompactTextRenderer(
                          isMedium: true,
                          isWhite: true,
                          content: getModelDisplayText(widget.reply),
                          onResolveEvent: resolvers.eventResolver,
                          onResolveProfile: resolvers.profileResolver,
                          onResolveEmoji: resolvers.emojiResolver,
                        ),
                      ),
                    ],
                  ),
                  const AppGap.s2(),
                  AppText.reg12(
                    widget.reply.author.value?.name ??
                        formatNpub(widget.reply.author.value?.npub ?? ''),
                    color: theme.colors.white66,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomBar: AppBottomBarReply(
        onAddTap: (model) => print(model),
        onReplyTap: (model) => print(model),
        onVoiceTap: (model) => print(model),
        onActions: (model) => print(model),
        model: widget.reply,
        onResolveEvent: resolvers.eventResolver,
        onResolveProfile: resolvers.profileResolver,
        onResolveEmoji: resolvers.emojiResolver,
      ),
      children: [
        AppReply(
          reply: widget.reply,
          onResolveEvent: resolvers.eventResolver,
          onResolveProfile: resolvers.profileResolver,
          onResolveEmoji: resolvers.emojiResolver,
          onResolveHashtag: resolvers.hashtagResolver,
          onLinkTap: (url) => print(url),
          onProfileTap: (profile) => print(profile),
        ),
        Expanded(
          child: AppContainer(
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
                  content: repliesState is StorageLoading
                      ? const AppLoadingFeed(type: LoadingFeedType.chat)
                      : AppContainer(
                          padding: AppEdgeInsets.all(AppGapSize.s6),
                          child: Column(
                            children: replies
                                .map((reply) => Column(children: [
                                      AppMessageStack(
                                        replies: [reply],
                                        onResolveEvent: resolvers.eventResolver,
                                        onResolveProfile:
                                            resolvers.profileResolver,
                                        onResolveEmoji: resolvers.emojiResolver,
                                        onResolveHashtag:
                                            resolvers.hashtagResolver,
                                        onLinkTap: (url) => print(url),
                                        onActions: (model) => print(model),
                                        onReply: (model) => print(model),
                                        onReactionTap: (model) => print(model),
                                        onZapTap: (model) => print(model),
                                        onProfileTap: (profile) =>
                                            print(profile),
                                      ),
                                      const AppGap.s8(),
                                    ]))
                                .toList(),
                          ),
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
                  content: DetailsTab(model: widget.reply),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
