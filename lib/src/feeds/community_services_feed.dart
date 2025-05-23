import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/resolvers.dart';

class CommunityServicesFeed extends ConsumerWidget {
  final Community community;

  const CommunityServicesFeed({
    super.key,
    required this.community,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(query<Service>());

    if (state case StorageLoading()) {
      return const AppLoadingFeed();
    }

    final services = state.models.cast<Service>();

    return AppContainer(
      child: Column(
        children: [
          for (final service in services)
            Column(
              children: [
                AppFeedService(
                  service: service,
                  isUnread: true,
                  onTap: (event) =>
                      context.push('/service/${event.id}', extra: event),
                ),
                const AppGap.s12(),
              ],
            ),
        ],
      ),
    );
  }
}
