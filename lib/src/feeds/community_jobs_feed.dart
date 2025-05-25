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
      return const AppLoadingFeed();
    }

    final jobs = state.models.cast<Job>();

    return AppContainer(
      padding: const AppEdgeInsets.all(AppGapSize.s12),
      child: Column(
        children: [
          for (final job in jobs)
            Column(
              children: [
                AppJobCard(
                  job: job,
                  isUnread: true,
                  onTap: (event) =>
                      context.push('/job/${event.id}', extra: event),
                ),
                const AppGap.s12(),
              ],
            ),
        ],
      ),
    );
  }
}
