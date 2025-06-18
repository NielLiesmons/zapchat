import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/resolvers.dart';

class CommunityArticlesFeed extends ConsumerWidget {
  final Community community;

  const CommunityArticlesFeed({
    super.key,
    required this.community,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolvers = ref.read(resolversProvider);
    final state = ref.watch(query<Article>());

    if (state case StorageLoading()) {
      return const LabLoadingFeed();
    }

    final articles = state.models.cast<Article>();

    return Column(
      children: [
        for (final article in articles)
          LabFeedArticle(
            article: article,
            topThreeReplyProfiles: ref.watch(
              resolvers.topThreeReplyProfilesResolver(article),
            ),
            totalReplyProfiles: ref.watch(
              resolvers.totalReplyProfilesResolver(article),
            ),
            isUnread: true,
            onTap: (event) =>
                context.push('/article/${event.id}', extra: event),
            onProfileTap: (profile) =>
                context.push('/profile/${profile.npub}', extra: profile),
          ),
      ],
    );
  }
}
