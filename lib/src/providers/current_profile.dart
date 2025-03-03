import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zaplab_design/zaplab_design.dart';

part 'current_profile.g.dart';

@riverpod
class CurrentProfile extends _$CurrentProfile {
  @override
  Profile build() {
    // In a real app, this would come from secure storage or authentication
    return Profile(
      npub: 'npub4',
      profileName: 'Niel Liesmons',
      profilePicUrl:
          'https://cdn.satellite.earth/946822b1ea72fd3710806c07420d6f7e7d4a7646b2002e6cc969bcf1feaa1009.png',
    );
  }

  void setCurrentProfile(Profile profile) {
    state = profile;
  }
}
