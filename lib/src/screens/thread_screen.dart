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

    // Record in history
    ref.read(historyProvider.notifier).addEntry(widget.thread);
    final recentHistory = ref.watch(recentHistoryItemsProvider(
        context, widget.thread.id)); // Get latest 3 history entries

    // Get data
    final resolvers = ref.read(resolversProvider);
    final communities =
        ref.watch(query<Community>()).models.cast<Community>().toList();
    final replies = ref.watch(query<Comment>()).models.cast<Comment>().toList();

    return LabScreen(
      history: recentHistory,
      onHomeTap: () => Navigator.of(context).pop(),
      alwaysShowTopBar: false,
      topBarContent: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LabProfilePic.s40(widget.thread.author.value),
          const LabGap.s12(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LabGap.s2(),
                Row(
                  children: [
                    LabEmojiContentType(
                      contentType: getModelContentType(widget.thread),
                      size: 16,
                    ),
                    const LabGap.s10(),
                    Expanded(
                      child: LabCompactTextRenderer(
                        model: widget.thread,
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
                const LabGap.s2(),
                LabText.reg12(
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
            LabThread(
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
                    content: Column(
                      children: [
                        ...replies.map((reply) {
                          return LabFeedThread(
                            reply: reply,
                            topThreeReplyProfiles: ref.watch(
                                resolvers.topThreeReplyProfilesResolver(reply)),
                            totalReplyProfiles: ref.watch(
                                resolvers.totalReplyProfilesResolver(reply)),
                            onTap: (reply) => context.push('/reply/${reply.id}',
                                extra: reply),
                            onReply: (reply) =>
                                context.push('/reply-to/${reply.id}'),
                            onActions: (reply) =>
                                context.push('/actions/${reply.id}'),
                            onReactionTap: (reply) =>
                                context.push('/reactions/${reply.id}'),
                            onZapTap: (reply) =>
                                context.push('/zaps/${reply.id}'),
                            onResolveEvent: resolvers.eventResolver,
                            onResolveProfile: resolvers.profileResolver,
                            onResolveEmoji: resolvers.emojiResolver,
                            onResolveHashtag: resolvers.hashtagResolver,
                            onLinkTap: (url) {
                              print(url);
                            },
                            onProfileTap: (profile) => context.push(
                                '/profile/${profile.npub}',
                                extra: profile),
                          );
                        }).toList(),
                      ],
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
