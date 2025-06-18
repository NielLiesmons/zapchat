import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      return const LabLoadingFeed(type: LoadingFeedType.thread);
    }

    final communities = state.models.cast<Community>();
    final relevantProfiles = state2.models.cast<Profile>();

    return LabContainer(
      padding: const LabEdgeInsets.only(
        top: LabGapSize.s12,
        left: LabGapSize.s12,
        right: LabGapSize.s12,
      ),
      child: Column(
        children: [
          for (final community in communities)
            Column(
              children: [
                LabCommunityCard(
                  community: community,
                  onTap: () {},
                  profile: profile,
                  profileLabel: "Dictator",
                  relevantProfiles: relevantProfiles,
                  relevantProfilesDescription: "Followers in\nyour network",
                  onProfilesTap: () {},
                ),
                const LabGap.s12(),
              ],
            ),
        ],
      ),
    );
  }
}
