import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      return const LabLoadingFeed();
    }

    final services = state.models.cast<Service>();

    return LabContainer(
      child: Column(
        children: [
          for (final service in services)
            Column(
              children: [
                LabFeedService(
                  service: service,
                  isUnread: true,
                  onTap: (model) =>
                      context.push('/service/${model.id}', extra: model),
                  onProfileTap: (profile) =>
                      context.push('/service/${profile.npub}', extra: profile),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
