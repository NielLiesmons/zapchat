import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/resolvers.dart';

class ProfileCommunitiesFeed extends ConsumerWidget {
  final Profile profile;

  const ProfileCommunitiesFeed({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(query<Community>());
    final state2 = ref.watch(query<Profile>());

    if (state case StorageLoading()) {
      return const AppLoadingFeed(type: LoadingFeedType.thread);
    }

    final communities = state.models.cast<Community>();
    final relevantProfiles = state2.models.cast<Profile>();

    return AppContainer(
      padding: const AppEdgeInsets.only(
        top: AppGapSize.s12,
        left: AppGapSize.s12,
        right: AppGapSize.s12,
      ),
      child: Column(
        children: [
          for (final community in communities)
            Column(
              children: [
                AppCommunityCard(
                  community: community,
                  onTap: () {},
                  profile: profile,
                  profileLabel: "Dictator",
                  relevantProfiles: relevantProfiles,
                  relevantProfilesDescription: "Followers in\nyour network",
                  onProfilesTap: () {},
                ),
                const AppGap.s12(),
              ],
            ),
        ],
      ),
    );
  }
}
