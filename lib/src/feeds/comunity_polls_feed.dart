import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/resolvers.dart';

class CommunityPollsFeed extends ConsumerWidget {
  final Community community;

  const CommunityPollsFeed({
    super.key,
    required this.community,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pollState = ref.watch(query<Poll>());
    final pollResponseState = ref.watch(query<PollResponse>());

    if (pollState case StorageLoading()) {
      return const LabLoadingFeed();
    }

    final polls = pollState.models.cast<Poll>();
    final pollResponses = pollResponseState.models.cast<PollResponse>();
    final resolvers = ref.read(resolversProvider);

    return LabContainer(
      child: Column(
        children: [
          for (final poll in polls)
            Column(
              children: [
                LabFeedPoll(
                  poll: poll,
                  isUnread: true,
                  allVotes: pollResponses
                      // .where((response) => response.pollEventId == poll.id)
                      .toList(),
                  onOptionTap: (index) {},
                  onVotesTap: (index) {},
                  onProfileTap: (profile) =>
                      context.push('/profile/${profile.npub}', extra: profile),
                  onLinkTap: (url) {
                    print(url);
                  },
                  onResolveEvent: resolvers.eventResolver,
                  onResolveProfile: resolvers.profileResolver,
                  onResolveEmoji: resolvers.emojiResolver,
                  onResolveHashtag: resolvers.hashtagResolver,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
