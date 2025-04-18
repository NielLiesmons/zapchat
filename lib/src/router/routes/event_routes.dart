import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:zapchat/src/providers/resolvers.dart';
import 'package:zapchat/src/providers/search.dart';

List<GoRoute> get eventRoutes => [
      GoRoute(
        path: '/actions/:eventId',
        pageBuilder: (context, state) {
          final event = state.extra as Event;
          return AppSlideInModal(
            child: Consumer(
              builder: (context, ref, _) {
                return AppActionsModal(
                  event: event,
                  onEventTap: (event) {},
                  onReplyTap: (event) {
                    context.replace('/reply/${event.id}', extra: event);
                  },
                  recentEmoji: DefaultData.defaultEmoji,
                  recentAmounts: DefaultData.defaultAmounts,
                  onEmojiTap: (emoji) {},
                  onMoreEmojiTap: () {},
                  onZapTap: (event) {},
                  onMoreZapsTap: (event) {
                    return () =>
                        context.replace('/zap/${event.id}', extra: event);
                  },
                  onReportTap: (event) {},
                  onAddProfileTap: (event) {},
                  onOpenWithTap: (event) {},
                  onLabelTap: (event) {},
                  onShareTap: (event) {},
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
          final event = state.extra as Event;
          return AppSlideInModal(
            child: Consumer(
              builder: (context, ref, _) {
                return AppZapModal(
                  event: event,
                  otherZaps: [],
                  recentAmounts: DefaultData.defaultAmounts,
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
        path: '/reply/:eventId',
        pageBuilder: (context, state) {
          final event = state.extra as Event;
          return AppSlideInModal(
            child: Consumer(
              builder: (context, ref, _) {
                return AppReplyModal(
                  event: event,
                  onResolveEvent: ref.read(resolversProvider).eventResolver,
                  onResolveProfile: ref.read(resolversProvider).profileResolver,
                  onResolveEmoji: ref.read(resolversProvider).emojiResolver,
                  onSearchProfiles: ref.read(searchProvider).profileSearch,
                  onSearchEmojis: ref.read(searchProvider).emojiSearch,
                  onCameraTap: () {},
                  onEmojiTap: () {},
                  onGifTap: () {},
                  onAddTap: () {},
                  onSendTap: () {},
                  onChevronTap: () {},
                );
              },
            ),
          );
        },
      ),
    ];
