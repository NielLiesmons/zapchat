import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_profiles.dart';

final currentProfileProvider =
    StateNotifierProvider<CurrentProfileNotifier, Profile?>((ref) {
  return CurrentProfileNotifier(ref);
});

final profilesProvider =
    StateNotifierProvider<ProfilesNotifier, List<Profile>>((ref) {
  return ProfilesNotifier();
});

class CurrentProfileNotifier extends StateNotifier<Profile?> {
  CurrentProfileNotifier(this.ref) : super(null) {
    _loadProfile();
  }

  final Ref ref;
  static const String _profileKey = 'current_profile_pubkey';

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final pubkey = prefs.getString(_profileKey);
    if (pubkey != null) {
      // Find the profile in the user profiles list
      final userProfiles = ref.read(userProfilesProvider);
      final matchingProfile = userProfiles
          .where((up) => up.profile.pubkey == pubkey)
          .firstOrNull
          ?.profile;
      if (matchingProfile != null) {
        state = matchingProfile;
      }
    }
  }

  Future<void> setProfile(Profile profile) async {
    state = profile;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, profile.pubkey);
  }

  Future<void> clearProfile() async {
    state = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
  }
}

class ProfilesNotifier extends StateNotifier<List<Profile>> {
  ProfilesNotifier() : super([]);

  void setProfiles(List<Profile> profiles) {
    state = profiles;
  }
}
