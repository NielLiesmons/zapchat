import 'dart:io';

import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';
import '../../providers/resolvers.dart';

class MailTab extends StatelessWidget {
  const MailTab({super.key});

  TabData tabData(BuildContext context) {
    return TabData(
      label: 'Mail',
      icon: const LabEmojiContentType(contentType: 'mail'),
      content: HookConsumer(
        builder: (context, ref, _) {
          final mails = ref.watch(query<Mail>()).models.cast<Mail>();

          return mails != null // TODO: actually check for empty state
              ? Column(
                  children: [
                    for (final mail in mails)
                      LabFeedMail(
                        isUnread: true,
                        mail: mail,
                        onTap: (event) =>
                            context.push('/mail/${event.id}', extra: event),
                        onProfileTap: (profile) => context
                            .push('/profile/${profile.npub}', extra: profile),
                        onSwipeLeft: (model) => {},
                        onSwipeRight: (model) => {},
                        onResolveEvent:
                            ref.read(resolversProvider).eventResolver,
                        onResolveProfile:
                            ref.read(resolversProvider).profileResolver,
                        onResolveEmoji:
                            ref.read(resolversProvider).emojiResolver,
                      ),
                  ],
                )
              : LabContainer(
                  padding: const LabEdgeInsets.all(LabGapSize.s12),
                  child: LabModelEmptyStateCard(
                    contentType: "mail",
                    onCreateTap: () {},
                  ),
                );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => tabData(context).content;
}
