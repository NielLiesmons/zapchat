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

// Default search implementation
class DefaultSearch extends Search {
  DefaultSearch()
      : super(
          profileSearch: (query) async {
            // TODO: Implement profile search
            return [];
          },
          emojiSearch: (query) async {
            // TODO: Implement emoji search
            return [];
          },
        );
}

final searchProvider = Provider<Search>((ref) {
  return DefaultSearch();
});
