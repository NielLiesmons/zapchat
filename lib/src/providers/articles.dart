import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'dummy_data.dart';

part 'articles.g.dart';

@riverpod
class Articles extends _$Articles {
  @override
  Map<String, List<Article>> build() {
    return dummyArticles;
  }

  void addArticle(String npub, Article article) {
    final articles = state[npub] ?? [];
    state = {
      ...state,
      npub: [...articles, article]
    };
  }

  List<Article> getArticles(String npub) => state[npub] ?? [];

  Article? getLastArticle(String npub) =>
      state[npub]?.isNotEmpty == true ? state[npub]!.first : null;
}
