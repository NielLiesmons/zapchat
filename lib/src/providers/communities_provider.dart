import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';

class CommunitiesState {
  final Map<String, String>
      latestSeenMessageIds; // communityId -> latest seen message ID
  final Map<String, DateTime>
      latestSeenMessageTimestamps; // communityId -> latest seen message timestamp

  const CommunitiesState({
    this.latestSeenMessageIds = const {},
    this.latestSeenMessageTimestamps = const {},
  });

  CommunitiesState copyWith({
    Map<String, String>? latestSeenMessageIds,
    Map<String, DateTime>? latestSeenMessageTimestamps,
  }) {
    return CommunitiesState(
      latestSeenMessageIds: latestSeenMessageIds ?? this.latestSeenMessageIds,
      latestSeenMessageTimestamps:
          latestSeenMessageTimestamps ?? this.latestSeenMessageTimestamps,
    );
  }
}

class CommunitiesNotifier extends StateNotifier<CommunitiesState> {
  CommunitiesNotifier() : super(const CommunitiesState());

  // Update the latest seen message for a community
  void updateLatestSeenMessage(
      String communityId, String messageId, DateTime timestamp) {
    final newLatestSeenMessageIds =
        Map<String, String>.from(state.latestSeenMessageIds);
    final newLatestSeenMessageTimestamps =
        Map<String, DateTime>.from(state.latestSeenMessageTimestamps);

    newLatestSeenMessageIds[communityId] = messageId;
    newLatestSeenMessageTimestamps[communityId] = timestamp;

    state = state.copyWith(
      latestSeenMessageIds: newLatestSeenMessageIds,
      latestSeenMessageTimestamps: newLatestSeenMessageTimestamps,
    );
  }

  // Get latest seen message ID for a community
  String? getLatestSeenMessageId(String communityId) {
    return state.latestSeenMessageIds[communityId];
  }

  // Get latest seen message timestamp for a community
  DateTime? getLatestSeenMessageTimestamp(String communityId) {
    return state.latestSeenMessageTimestamps[communityId];
  }
}

// Provider instance
final communitiesProvider =
    StateNotifierProvider<CommunitiesNotifier, CommunitiesState>((ref) {
  return CommunitiesNotifier();
});
