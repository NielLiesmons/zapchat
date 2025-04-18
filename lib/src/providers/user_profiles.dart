import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';

part 'user_profiles.g.dart';

@riverpod
class UserProfiles extends _$UserProfiles {
  static const String _currentProfileKey = 'current_profile_pubkey';

  @override
  Future<(List<Profile>, Profile?)> build() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pubkey = prefs.getString(_currentProfileKey);

      // Load profiles from storage
      final profiles =
          (await ref.read(storageNotifierProvider.notifier).querySync(
                    RequestFilter(kinds: {0}), // Kind 0 is for profiles
                  ))
              .cast<Profile>();

      // Set current profile if we have a pubkey
      Profile? currentProfile;
      if (profiles.isNotEmpty) {
        currentProfile = pubkey != null
            ? profiles.firstWhereOrNull((p) => p.pubkey == pubkey) ??
                profiles.first
            : profiles.first;
      }

      return (profiles, currentProfile);
    } catch (e) {
      // If anything fails, throw the error to let Riverpod handle it
      throw e;
    }
  }

  Future<void> addProfile(Profile profile) async {
    if (!state.hasValue) {
      state = AsyncData(([profile], profile));
      return;
    }

    final (profiles, currentProfile) = state.value!;
    if (!profiles.any((p) => p.pubkey == profile.pubkey)) {
      state = AsyncData(([...profiles, profile], currentProfile));
    }
  }

  Future<void> removeProfile(Profile profile) async {
    if (!state.hasValue) return;

    final (profiles, currentProfile) = state.value!;
    final newProfiles =
        profiles.where((p) => p.pubkey != profile.pubkey).toList();
    Profile? newCurrentProfile = currentProfile;

    if (currentProfile?.pubkey == profile.pubkey) {
      newCurrentProfile = newProfiles.isNotEmpty ? newProfiles.first : null;
      if (newCurrentProfile != null) {
        await setCurrentProfile(newCurrentProfile);
      }
    }

    state = AsyncData((newProfiles, newCurrentProfile));
  }

  Future<void> reorderProfiles(int oldIndex, int newIndex) async {
    if (!state.hasValue) return;

    final (profiles, currentProfile) = state.value!;
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final List<Profile> newList = List.from(profiles);
    final Profile item = newList.removeAt(oldIndex);
    newList.insert(newIndex, item);
    state = AsyncData((newList, currentProfile));
  }

  Future<void> updateProfile(Profile profile) async {
    if (!state.hasValue) return;

    final (profiles, currentProfile) = state.value!;
    final newProfiles =
        profiles.map((p) => p.pubkey == profile.pubkey ? profile : p).toList();
    Profile? newCurrentProfile = currentProfile;

    if (currentProfile?.pubkey == profile.pubkey) {
      newCurrentProfile = profile;
    }

    state = AsyncData((newProfiles, newCurrentProfile));
  }

  Future<void> setCurrentProfile(Profile profile) async {
    if (!state.hasValue) return;

    final (profiles, _) = state.value!;
    if (profiles.any((p) => p.pubkey == profile.pubkey)) {
      state = AsyncData((profiles, profile));
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currentProfileKey, profile.pubkey);
    }
  }

  Future<void> clearCurrentProfile() async {
    if (!state.hasValue) return;

    final (profiles, _) = state.value!;
    state = AsyncData((profiles, null));
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentProfileKey);
  }
}
