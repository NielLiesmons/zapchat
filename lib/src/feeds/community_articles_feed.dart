import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../resolvers.dart';
import '../providers/user_profiles.dart';

class CommunityArticlesFeed extends ConsumerWidget {
  final Community community;

  const CommunityArticlesFeed({
    super.key,
    required this.community,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final state = ref.watch(query<Article>());

    // if (state case StorageLoading()) {
    //   return const AppLoadingFeed();
    // }

    // final articles = state.models.cast<Article>();

    return Column(
      children: [
        // for (final article in articles)
        //   AppArticleCard(
        //     article: article,
        //     onTap: () => context.push('/article/${article.id}'),
        //   ),
      ],
    );
  }
}
