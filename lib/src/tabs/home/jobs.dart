import 'package:go_router/go_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';
import '../../providers/resolvers.dart';

class JobsTab extends StatelessWidget {
  const JobsTab({super.key});

  TabData tabData(BuildContext context) {
    final theme = AppTheme.of(context);

    return TabData(
      label: 'Jobs',
      icon: const AppEmojiContentType(contentType: 'job'),
      content: HookConsumer(
        builder: (context, ref, _) {
          final jobs = ref.watch(query<Job>()).models.cast<Job>();

          return AppContainer(
            padding: const AppEdgeInsets.all(AppGapSize.s12),
            child: Column(
              children: [
                for (final job in jobs)
                  Column(
                    children: [
                      AppJobCard(
                        job: job,
                        onTap: (model) => context.push('/job/${model.id}'),
                        isUnread: true,
                        onResolveEvent:
                            ref.read(resolversProvider).eventResolver,
                        onResolveProfile:
                            ref.read(resolversProvider).profileResolver,
                        onResolveEmoji:
                            ref.read(resolversProvider).emojiResolver,
                      ),
                      const AppGap.s12(),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => tabData(context).content;
}
