import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:go_router/go_router.dart';

class ArticlesTab extends StatelessWidget {
  const ArticlesTab({super.key});

  TabData tabData(BuildContext context) {
    return TabData(
      label: 'Articles',
      icon: const AppEmojiContentType(contentType: 'article'),
      content: HookConsumer(
        builder: (context, ref, _) {
          final state = ref.watch(query<Article>());

          if (state case StorageLoading()) {
            return const AppLoadingFeed();
          }

          final articles = state.models.cast<Article>();
          return AppContainer(
            child: Column(
              children: [
                for (final article in articles)
                  AppFeedArticle(
                    article: article,
                    isUnread: true,
                    onTap: (event) =>
                        context.push('/article/${event.id}', extra: event),
                    onProfileTap: (profile) => context
                        .push('/profile/${profile.npub}', extra: profile),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => tabData(context).content;
}
