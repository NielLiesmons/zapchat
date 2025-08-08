import 'package:models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zaplab_design/zaplab_design.dart';

class Search {
  final NostrProfileSearch profileSearch;
  final NostrEmojiSearch emojiSearch;

  const Search({
    required this.profileSearch,
    required this.emojiSearch,
  });
}

// Create a provider that ensures profiles are available
final profileSearchProvider = Provider<NostrProfileSearch>((ref) {
  // Watch profiles in the provider context to ensure they're available
  final profilesState = ref.watch(query<Profile>(limit: 21));

  return (queryText) async {
    try {
      final allProfiles = profilesState.models.cast<Profile>().toList();

      // Filter profiles based on query text
      if (queryText.isEmpty) {
        return allProfiles;
      }

      return allProfiles.where((profile) {
        final name = profile.name?.toLowerCase() ?? '';
        final query = queryText.toLowerCase();
        return name.contains(query);
      }).toList();
    } catch (e) {
      return [];
    }
  };
});

// Create emoji search provider
final emojiSearchProvider = Provider<NostrEmojiSearch>((ref) {
  return (queryText) async {
    // For now, just return all default emoji
    // TODO: Add filtering based on queryText when needed
    return LabDefaultData.defaultEmoji;
  };
});

final searchProvider = Provider<Search>((ref) {
  return Search(
    profileSearch: ref.watch(profileSearchProvider),
    emojiSearch: ref.watch(emojiSearchProvider),
  );
});
