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

List<GoRoute> get eventRoutes => [
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
                  onResolveEvent: ref.read(resolversProvider).eventResolver,
                  onResolveProfile: ref.read(resolversProvider).profileResolver,
                  onResolveEmoji: ref.read(resolversProvider).emojiResolver,
                  onSearchProfiles: ref.read(searchProvider).profileSearch,
                  onSearchEmojis: ref.read(searchProvider).emojiSearch,
                  onCameraTap: () {},
                  onEmojiTap: () {},
                  onGifTap: () {},
                  onAddTap: () {},
                  onSendTap: () {
                    context.pop();
                  },
                  onChevronTap: () {
                    context.pop();
                  },
                );
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
