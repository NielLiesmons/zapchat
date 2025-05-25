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
      icon: const AppEmojiContentType(contentType: 'mail'),
      content: HookConsumer(
        builder: (context, ref, _) {
          final mails = ref.watch(query<Mail>()).models.cast<Mail>();

          return Column(
            children: [
              for (final mail in mails)
                AppFeedMail(
                  isUnread: true,
                  mail: mail,
                  onTap: (event) =>
                      context.push('/mail/${event.id}', extra: event),
                  onSwipeLeft: (model) => {},
                  onSwipeRight: (model) => {},
                  onResolveEvent: ref.read(resolversProvider).eventResolver,
                  onResolveProfile: ref.read(resolversProvider).profileResolver,
                  onResolveEmoji: ref.read(resolversProvider).emojiResolver,
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => tabData(context).content;
}
