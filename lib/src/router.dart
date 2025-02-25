import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'homepage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/messages.dart';
import 'providers/chat_screen.dart';
import 'providers/posts.dart';
import 'providers/articles.dart';

final goRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/chat/:npub',
      pageBuilder: (context, state) {
        final npub = state.pathParameters['npub']!;
        return AppBottomSlide(
          child: Consumer(
            builder: (context, ref, _) {
              final messages =
                  ref.watch(messagesProvider.notifier).getMessages(npub);
              final posts = ref.watch(postsProvider.notifier).getPosts(npub);
              final articles =
                  ref.watch(articlesProvider.notifier).getArticles(npub);
              final profile = ref.watch(chatScreenDataProvider)[npub];

              return AppChatScreen(
                npub: npub,
                profileName: profile?.profileName ?? '',
                profilePicUrl: profile?.profilePicUrl ?? '',
                messages: messages,
                posts: posts,
                articles: articles,
                mainCount: profile?.mainCount,
                contentCounts: profile?.contentCounts ?? {},
                onNostrEvent: (event) {
                  // Handle incoming events
                },
                onHomeTap: () => context.pop(),
              );
            },
          ),
        );
      },
    ),
    // TODO: Implement content screen
  ],
);
