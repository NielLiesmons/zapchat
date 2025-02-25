import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'dummy_data.dart';

part 'posts.g.dart';

@riverpod
class Posts extends _$Posts {
  @override
  Map<String, List<Post>> build() {
    return dummyPosts;
  }

  void addPost(String npub, Post post) {
    final posts = state[npub] ?? [];
    state = {
      ...state,
      npub: [...posts, post]
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp)),
    };
  }

  List<Post> getPosts(String npub) => state[npub] ?? [];

  Post? getLastPost(String npub) =>
      state[npub]?.isNotEmpty == true ? state[npub]!.first : null;
}
