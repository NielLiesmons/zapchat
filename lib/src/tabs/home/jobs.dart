import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';

class JobsTab extends StatelessWidget {
  const JobsTab({super.key});

  TabData tabData(BuildContext context) {
    return TabData(
      label: 'Jobs',
      icon: const LabEmojiContentType(contentType: 'job'),
      content: HookConsumer(
        builder: (context, ref, _) {
          final jobs = ref.watch(query<Job>()).models.cast<Job>();

          return LabContainer(
            padding: const LabEdgeInsets.all(LabGapSize.s12),
            child: Column(
              children: [
                for (final job in jobs)
                  Column(
                    children: [
                      LabJobCard(
                        job: job,
                        onTap: (model) => context.push('/job/${model.id}'),
                        isUnread: true,
                      ),
                      const LabGap.s12(),
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
