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

// Add cache classes
class _ResolverCache<T> {
  final Map<String, Future<T>> _cache = {};

  Future<T> getOrCreate(String key, Future<T> Function() create) {
    return _cache.putIfAbsent(key, create);
  }

  void clear() {
    _cache.clear();
  }
}

// Create a provider that ensures profiles are available
final profileSearchProvider = Provider<NostrProfileSearch>((ref) {
  // Watch profiles in the provider context to ensure they're available
  final profilesState = ref.watch(query<Profile>());

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

final searchProvider = Provider<Search>((ref) {
  return Search(
    profileSearch: ref.watch(profileSearchProvider),
    emojiSearch: (queryText) async {
      // TODO: Implement emoji search
      return [];
    },
  );
});
