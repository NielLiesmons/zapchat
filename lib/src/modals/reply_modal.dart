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
  late LabTabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = LabTabController(length: 4);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final resolvers = ref.read(resolversProvider);
    final repliesState = ref.watch(query<Comment>(
      where: (comment) => comment.parentModel.value?.id == widget.reply.id,
    ));
    final replies = repliesState.models.cast<Comment>().toList();

    return LabModal(
      includePadding: false,
      topBar: LabContainer(
        padding: const LabEdgeInsets.all(LabGapSize.s12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LabProfilePic.s40(widget.reply.author.value),
            const LabGap.s12(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LabGap.s2(),
                  Row(
                    children: [
                      LabEmojiContentType(
                        contentType: getModelContentType(widget.reply),
                        size: 16,
                      ),
                      const LabGap.s10(),
                      Expanded(
                        child: LabCompactTextRenderer(
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
                  const LabGap.s2(),
                  LabText.reg12(
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
      bottomBar: LabBottomBarReply(
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
        LabReply(
          reply: widget.reply,
          onResolveEvent: resolvers.eventResolver,
          onResolveProfile: resolvers.profileResolver,
          onResolveEmoji: resolvers.emojiResolver,
          onResolveHashtag: resolvers.hashtagResolver,
          onLinkTap: (url) => print(url),
          onProfileTap: (profile) => print(profile),
        ),
        Expanded(
          child: LabContainer(
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
                  content: repliesState is StorageLoading
                      ? const LabLoadingFeed(type: LoadingFeedType.chat)
                      : LabContainer(
                          padding: LabEdgeInsets.all(LabGapSize.s6),
                          child: Column(
                            children: replies
                                .map((reply) => Column(children: [
                                      LabMessageStack(
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
                                      const LabGap.s8(),
                                    ]))
                                .toList(),
                          ),
                        ),
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
                  label: 'Labels',
                  icon: LabIcon.s24(
                    theme.icons.characters.label,
                    outlineColor: theme.colors.white66,
                    outlineThickness: LabLineThicknessData.normal().medium,
                  ),
                  content: const LabText.reg14('Labels content'),
                ),
                TabData(
                  label: 'Details',
                  icon: LabIcon.s24(
                    theme.icons.characters.details,
                    outlineColor: theme.colors.white66,
                    outlineThickness: LabLineThicknessData.normal().medium,
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
