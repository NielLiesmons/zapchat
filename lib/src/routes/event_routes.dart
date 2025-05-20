import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:zapchat/src/providers/resolvers.dart';
import 'package:zapchat/src/providers/search.dart';
import 'package:zapchat/src/screens/thread_screen.dart';
import 'package:zapchat/src/screens/article_screen.dart';
import 'package:zapchat/src/screens/mail_screen.dart';
import 'package:zapchat/src/modals/reply_modal.dart';

String getModelRoute(String modelType) {
  return switch (modelType.toLowerCase()) {
    'thread' => '/thread',
    'article' => '/article',
    'mail' => '/mail',
    'book' => '/book',
    'task' => '/task',
    'job' => '/job',
    'group' => '/group',
    'community' => '/community',
    _ => '/nostr-publication', // Default to nostr-publication if unknown
  };
}

List<GoRoute> get eventRoutes => [
      GoRoute(
        path: '/:eventId',
        redirect: (context, state) {
          final model = state.extra as Model;
          final route = getModelRoute(model.runtimeType.toString());
          return '$route/${state.pathParameters['eventId']}';
        },
      ),
      GoRoute(
        path: '/actions/:eventId',
        pageBuilder: (context, state) {
          final model = state.extra as Model;
          return AppSlideInModal(
            child: Consumer(
              builder: (context, ref, _) {
                return AppActionsModal(
                  model: model,
                  onModelTap: (model) {},
                  onReplyTap: (model) {
                    context.replace('/reply-to/${model.id}', extra: model);
                  },
                  recentEmoji: AppDefaultData.defaultEmoji,
                  recentAmounts: AppDefaultData.defaultAmounts,
                  onEmojiTap: (emoji) {},
                  onMoreEmojiTap: () {},
                  onZapTap: (model) {},
                  onMoreZapsTap: (model) {
                    return () =>
                        context.replace('/zap/${model.id}', extra: model);
                  },
                  onReportTap: (model) {},
                  onAddProfileTap: (model) {},
                  onOpenWithTap: (model) {},
                  onLabelTap: (model) {},
                  onShareTap: (model) {},
                  onResolveEvent: ref.read(resolversProvider).eventResolver,
                  onResolveProfile: ref.read(resolversProvider).profileResolver,
                  onResolveEmoji: ref.read(resolversProvider).emojiResolver,
                  onResolveHashtag: (identifier) async {
                    await Future.delayed(const Duration(seconds: 1));
                    return () {};
                  },
                );
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/zap/:eventId',
        pageBuilder: (context, state) {
          final model = state.extra as Model;
          return AppSlideInModal(
            child: Consumer(
              builder: (context, ref, _) {
                return AppZapModal(
                  model: model,
                  otherZaps: [],
                  recentAmounts: AppDefaultData.defaultAmounts,
                  onResolveEvent: ref.read(resolversProvider).eventResolver,
                  onResolveProfile: ref.read(resolversProvider).profileResolver,
                  onResolveEmoji: ref.read(resolversProvider).emojiResolver,
                  onSearchProfiles: ref.read(searchProvider).profileSearch,
                  onSearchEmojis: ref.read(searchProvider).emojiSearch,
                  onCameraTap: () {},
                  onEmojiTap: () {},
                  onGifTap: () {},
                  onAddTap: () {},
                );
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/reply-to/:eventId',
        pageBuilder: (context, state) {
          final model = state.extra as Model;
          return AppSlideInModal(
            child: Consumer(
              builder: (context, ref, _) {
                return ReplyModal(
                  model: model,
                );
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/nostr-publication/:eventId',
        pageBuilder: (context, state) {
          final model = state.extra as Model;
          // TODO: Implement general nostr publication screen
          return AppSlideInScreen(
            child: Consumer(
              builder: (context, ref, _) {
                return AppText.h1('Nostr publication');
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/mail/:eventId',
        pageBuilder: (context, state) {
          final model = state.extra as Model;
          return AppSlideInScreen(
            child: Consumer(
              builder: (context, ref, _) {
                return MailScreen(
                  mail: model as Mail,
                );
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/thread/:eventId',
        pageBuilder: (context, state) {
          final event = state.extra as Model;
          return AppSlideInScreen(
            child: Consumer(
              builder: (context, ref, _) {
                return ThreadScreen(
                  thread: event as Note,
                );
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/article/:eventId',
        pageBuilder: (context, state) {
          final event = state.extra as Model;
          return AppSlideInScreen(
            child: Consumer(
              builder: (context, ref, _) {
                return ArticleScreen(
                  article: event as Article,
                );
              },
            ),
          );
        },
      ),
    ];
