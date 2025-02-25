import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'dummy_data.dart';

part 'chat_screen.g.dart';

@riverpod
class ChatScreenData extends _$ChatScreenData {
  @override
  Map<String, ChatScreenProfile> build() {
    return dummyChatScreenProfiles; // Initialize with dummy data directly
  }

  void upsertProfile(String npub, ChatScreenProfile data) {
    state = {...state, npub: data};
  }

  ChatScreenProfile? getProfile(String npub) => state[npub];
}

class ChatScreenProfile {
  final String npub;
  final String profileName;
  final String profilePicUrl;
  final Map<String, int> contentCounts;
  final int? mainCount;

  ChatScreenProfile({
    required this.npub,
    required this.profileName,
    required this.profilePicUrl,
    this.contentCounts = const {},
    this.mainCount,
  });
}
