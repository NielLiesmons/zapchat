import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityJobsFeed extends ConsumerWidget {
  final Community community;

  const CommunityJobsFeed({
    super.key,
    required this.community,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(query<Job>());

    if (state case StorageLoading()) {
      return const LabLoadingFeed();
    }

    final jobs = state.models.cast<Job>();

    return LabContainer(
      padding: const LabEdgeInsets.all(LabGapSize.s12),
      child: Column(
        children: [
          for (final job in jobs)
            Column(
              children: [
                LabJobCard(
                  job: job,
                  isUnread: true,
                  onTap: (event) =>
                      context.push('/job/${event.id}', extra: event),
                ),
                const LabGap.s12(),
              ],
            ),
        ],
      ),
    );
  }
}
