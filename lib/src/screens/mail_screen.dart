import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/resolvers.dart';
import '../providers/history.dart';

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
    final theme = AppTheme.of(context);

    // Record in history
    ref.read(historyProvider.notifier).addEntry(widget.mail);

    // Get data
    final resolvers = ref.read(resolversProvider);
    final state = ref.watch(query<Profile>());
    final recipients = widget.mail.recipientPubkeys
        .map((pubkey) => state.models.cast<Profile>().firstWhere(
              (profile) => profile.pubkey == pubkey,
              orElse: () => PartialProfile(
                name: formatNpub(pubkey),
                pictureUrl: null,
              ).dummySign(),
            ))
        .toList();

    return AppScreen(
      onHomeTap: () => Navigator.of(context).pop(),
      alwaysShowTopBar: false,
      bottomBarContent: AppBottomBarMail(
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
          AppProfilePic.s40(widget.mail.author.value),
          const AppGap.s12(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppGap.s2(),
                Row(
                  children: [
                    AppEmojiContentType(
                      contentType: "mail",
                      size: 16,
                    ),
                    const AppGap.s10(),
                    Expanded(
                      child: AppText.med14(
                        widget.mail.title ?? 'No Subject',
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const AppGap.s2(),
                AppText.reg12(
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
            AppContainer(
              padding: const AppEdgeInsets.only(
                bottom: AppGapSize.s12,
                left: AppGapSize.s12,
                right: AppGapSize.s12,
              ),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.bold16(
                    widget.mail.title ?? 'No Subject',
                    maxLines: 2,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  const AppGap.s6(),
                  Row(
                    children: [
                      // AppSmallLabel(
                      //   'Urgent',
                      //   isEmphasized: true,
                      // ),
                      // const AppGap.s4(),
                      AppSmallLabel(
                        'Your Network',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const AppDivider(),
            AppContainer(
              padding: const AppEdgeInsets.all(AppGapSize.s12),
              child: Column(
                children: [
                  AppMail(
                    mail: widget.mail,
                    recipients: recipients,
                    currentProfile: ref.watch(Profile.signedInProfileProvider),
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
