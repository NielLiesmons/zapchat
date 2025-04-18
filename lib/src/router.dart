import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'homepage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'modals/preferences_modal.dart';
import 'modals/community_info_modal.dart';
import 'modals/community_pricing_modal.dart';
import 'modals/community_notifications_modal.dart';
import 'resolvers.dart';
import 'search.dart';
import 'screens/community_screen.dart';
import 'package:zapchat/src/screens/settings_screen.dart';

final goRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/community/:npub',
      pageBuilder: (context, state) {
        if (state.extra == null) {
          throw Exception('Community object is required');
        }
        final community = state.extra as Community;
        return AppSlideInScreen(
          child: CommunityScreen(community: community),
        );
      },
    ),
    GoRoute(
      path: '/chat/:npub/info',
      pageBuilder: (context, state) {
        if (state.extra == null) {
          throw Exception('Community object is required');
        }
        final community = state.extra as Community;
        return AppSlideInModal(
          child: CommunityInfoModal(community: community),
        );
      },
    ),
    GoRoute(
      path: '/chat/:npub/info/pricing',
      pageBuilder: (context, state) {
        final npub = state.pathParameters['npub']!;
        return AppSlideInModal(
          child: Consumer(
            builder: (context, ref, _) {
              final communityState =
                  ref.watch(query<Community>(authors: {npub}));

              if (communityState case StorageLoading()) {
                return const Center(child: AppLoadingDots());
              }

              final community = communityState.models.first;
              return CommunityPricingModal(community: community);
            },
          ),
        );
      },
    ),
    GoRoute(
      path: '/chat/:npub/info/notifications',
      pageBuilder: (context, state) {
        return AppSlideInModal(
          child: const CommunityNotificationsModal(),
        );
      },
    ),
    GoRoute(
      path: '/actions/:eventId',
      pageBuilder: (context, state) {
        if (state.extra == null) {
          throw Exception('Event object is required to open actions modal');
        }
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
                onMoreZapsTap: (event) {},
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
      path: '/reply/:eventId',
      pageBuilder: (context, state) {
        if (state.extra == null) {
          throw Exception('Event object is required to open actions modal');
        }
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
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) {
        return AppSlideInScreen(
          child: const SettingsScreen(),
        );
      },
    ),
    GoRoute(
      path: '/settings/appearance',
      pageBuilder: (context, state) {
        return AppSlideInModal(
          child: const PreferencesModal(),
        );
      },
    ),
    GoRoute(
      path: '/slotMachine',
      pageBuilder: (context, state) {
        final profileName = state.extra as String;

        return AppSlideInModal(
          child: AppSlotMachineModal(
            profileName: profileName,
          ),
        );
      },
    ),
    GoRoute(
      path: '/settings/get-started',
      pageBuilder: (context, state) {
        return AppSlideInModal(
          child: AppAddProfileModal(
            onStart: (profileName) {
              context.replace('/slotMachine', extra: profileName);
            },
            onAlreadyHaveKey: () {
              // Handle already have key case
            },
          ),
        );
      },
    ),

    // TODO: Implement content screen
  ],
);
