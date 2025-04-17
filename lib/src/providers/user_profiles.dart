import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserProfile {
  final Profile profile;
  final String? nsec; // Store the nsec for signing

  UserProfile({required this.profile, this.nsec});

  Map<String, dynamic> toJson() => {
        'profile': {
          'name': profile.name,
          'pictureUrl': profile.pictureUrl,
          'pubkey': profile.pubkey,
          'npub': profile.npub,
        },
        'nsec': nsec,
      };

  static Future<UserProfile> fromJson(Map<String, dynamic> json) async {
    try {
      final profileData = json['profile'] as Map<String, dynamic>;
      final partialProfile = PartialProfile(
        name: profileData['name'] as String? ?? '',
        pictureUrl: profileData['pictureUrl'] as String? ?? '',
      );
      final profile = await partialProfile.signWith(
        DummySigner(),
        withPubkey: profileData['pubkey'] as String,
      );
      return UserProfile(
        profile: profile,
        nsec: json['nsec'] as String?,
      );
    } catch (e) {
      print('Error creating UserProfile from JSON: $e');
      print('JSON data: $json');
      rethrow;
    }
  }
}

final userProfilesProvider =
    StateNotifierProvider<UserProfilesNotifier, List<UserProfile>>((ref) {
  return UserProfilesNotifier();
});

class UserProfilesNotifier extends StateNotifier<List<UserProfile>> {
  UserProfilesNotifier() : super([]) {
    _loadProfiles();
  }

  static const String _profilesKey = 'user_profiles';

  Future<void> _loadProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final profilesJson = prefs.getString(_profilesKey);
    if (profilesJson != null && profilesJson.isNotEmpty) {
      try {
        print('Loading profiles from JSON: $profilesJson');
        final List<dynamic> profilesList = json.decode(profilesJson);
        print('Decoded profiles list: $profilesList');
        final loadedProfiles = await Future.wait(
          profilesList.map(
            (json) => UserProfile.fromJson(json as Map<String, dynamic>),
          ),
        );
        state = loadedProfiles;
        print('Successfully loaded ${loadedProfiles.length} profiles');
      } catch (e) {
        print('Error loading profiles: $e');
        print('Raw JSON data: $profilesJson');
        await prefs.remove(_profilesKey);
      }
    } else {
      print('No profiles found in SharedPreferences');
    }
  }

  Future<void> _saveProfiles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profilesJson = json.encode(state.map((p) => p.toJson()).toList());
      print('Saving profiles to JSON: $profilesJson');
      await prefs.setString(_profilesKey, profilesJson);
    } catch (e) {
      print('Error saving profiles: $e');
      rethrow;
    }
  }

  Future<void> addProfile(UserProfile profile) async {
    state = [...state, profile];
    await _saveProfiles();
  }

  Future<void> removeProfile(String pubkey) async {
    state = state.where((p) => p.profile.pubkey != pubkey).toList();
    await _saveProfiles();
  }

  Future<void> reorderProfiles(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final List<UserProfile> newList = List.from(state);
    final UserProfile item = newList.removeAt(oldIndex);
    newList.insert(newIndex, item);
    state = newList;
    await _saveProfiles();
  }

  Future<void> updateProfile(UserProfile profile) async {
    state = state
        .map((p) => p.profile.pubkey == profile.profile.pubkey ? profile : p)
        .toList();
    await _saveProfiles();
  }
}
