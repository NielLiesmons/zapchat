import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/resolvers.dart';
import '../providers/history.dart';
import 'package:go_router/go_router.dart';

class MailScreen extends ConsumerStatefulWidget {
  final Mail mail;

  const MailScreen({
    super.key,
    required this.mail,
  });

  @override
  ConsumerState<MailScreen> createState() => _MailScreenState();
}

class _MailScreenState extends ConsumerState<MailScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    // Record in history
    ref.read(historyProvider.notifier).addEntry(widget.mail);

    // Get data
    final resolvers = ref.read(resolversProvider);
    final profilesState = ref.watch(query<Profile>());
    final recipients = profilesState.models.cast<Profile>().toList();

    return LabScreen(
      onHomeTap: () => Navigator.of(context).pop(),
      alwaysShowTopBar: false,
      bottomBarContent: LabBottomBarMail(
        onAddTap: (mail) {},
        onMessageTap: (mail) {},
        onVoiceTap: (mail) {},
        onActions: (mail) {},
        model: widget.mail,
        onResolveEvent: resolvers.eventResolver,
        onResolveProfile: resolvers.profileResolver,
        onResolveEmoji: resolvers.emojiResolver,
      ),
      topBarContent: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LabProfilePic.s40(widget.mail.author.value),
          const LabGap.s12(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LabGap.s2(),
                Row(
                  children: [
                    LabEmojiContentType(
                      contentType: "mail",
                      size: 16,
                    ),
                    const LabGap.s10(),
                    Expanded(
                      child: LabText.med14(
                        widget.mail.title ?? 'No Subject',
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const LabGap.s2(),
                LabText.reg12(
                  widget.mail.author.value?.name ??
                      formatNpub(widget.mail.author.value?.npub ?? ''),
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
            if (LabPlatformUtils.isMobile) const LabGap.s8(),
            LabContainer(
              padding: const LabEdgeInsets.only(
                bottom: LabGapSize.s12,
                left: LabGapSize.s12,
                right: LabGapSize.s12,
              ),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabText.bold16(
                    widget.mail.title ?? 'No Subject',
                    maxLines: 2,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  const LabGap.s6(),
                  Row(
                    children: [
                      // LabSmallLabel(
                      //   'Urgent',
                      //   isEmphasized: true,
                      // ),
                      // const LabGap.s4(),
                      LabSmallLabel(
                        'Your Network',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const LabDivider(),
            LabContainer(
              padding: const LabEdgeInsets.all(LabGapSize.s12),
              child: Column(
                children: [
                  LabMail(
                    mail: widget.mail,
                    recipients: recipients,
                    activeProfile: ref.watch(
                        Signer.activeProfileProvider(LocalAndRemoteSource())),
                    onSwipeLeft: (mail) {
                      print('swipe left');
                    },
                    onSwipeRight: (mail) {
                      print('swipe right');
                    },
                    onResolveEvent: resolvers.eventResolver,
                    onResolveProfile: resolvers.profileResolver,
                    onResolveEmoji: resolvers.emojiResolver,
                    onResolveHashtag: resolvers.hashtagResolver,
                    onLinkTap: (url) {
                      print(url);
                    },
                    onProfileTap: (profile) => context
                        .push('/profile/${profile.npub}', extra: profile),
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
