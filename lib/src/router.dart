import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'homepage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/messages.dart';
import 'providers/chat_screen.dart';
import 'providers/articles.dart';
import 'modals/preferences_modal.dart';

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
        return AppSlideInScreen(
          child: Consumer(
            builder: (context, ref, _) {
              final messages =
                  ref.watch(messagesProvider.notifier).getMessages(npub);
              final state =
                  ref.watch(query(kinds: {1}, authors: {'a', 'b'}, limit: 5));
              final pstate = ref.watch(query(kinds: {0}));

              final articles =
                  ref.watch(articlesProvider.notifier).getArticles(npub);
              final profile = ref.watch(chatScreenDataProvider)[npub];

              return AppChatScreen(
                npub: npub,
                profileName: profile?.profileName ?? '',
                profilePicUrl: profile?.profilePicUrl ?? '',
                messages: messages,
                posts: List.castFrom(state.models),
                articles: articles,
                currentNpub: (pstate.models.first as Profile).npub,
                mainCount: profile?.mainCount,
                contentCounts: profile?.contentCounts ?? {},
                onHomeTap: () => context.pop(),
                onActions: (nevent) => context.push('/actions/$nevent'),
                onReply: (eventId) {},
                onReactionTap: (eventId) {},
                onZapTap: (eventId) {},
                onLinkTap: (url) {},
                onResolveEvent: (id) async => NostrEvent(
                  nevent: id,
                  npub: 'npub1test',
                  contentType: 'article',
                  title: 'Communi-keys',
                  imageUrl:
                      'https://cdn.satellite.earth/7273fad49b4c3a17a446781a330553e1bb8de7a238d6c6b6cee30b8f5caf21f4.png',
                  profileName: 'Niel Liesmons',
                  profilePicUrl:
                      'https://cdn.satellite.earth/946822b1ea72fd3710806c07420d6f7e7d4a7646b2002e6cc969bcf1feaa1009.png',
                  timestamp: DateTime.now(),
                  onTap: () {},
                ),
                onResolveProfile: (id) async => Profile(
                  npub: id,
                  profileName: 'Pip',
                  profilePicUrl: 'https://m.primal.net/IfSZ.jpg',
                  onTap: () {},
                ),
                onResolveEmoji: (id) async =>
                    'https://image.nostr.build/f1ac401d3f222908d2f80df7cfadc1d73f4e0afa3a3ff6e8421bf9f0b37372a6.gif',
                onResolveHashtag: (id) async => () {
                  print('Hashtag #$id tapped');
                },
              );
            },
          ),
        );
      },
    ),
    // Add the new actions modal route
    GoRoute(
      path: '/actions/:nevent',
      pageBuilder: (context, state) {
        final nevent = state.pathParameters['nevent']!;
        return AppSlideInModal(
          child: AppActionsModal(
            nevent: nevent,
            contentType: 'message',
            profileName: 'User',
            profilePicUrl: '',
            recentReactions: DefaultData.defaultReactions,
            recentAmounts: DefaultData.defaultAmounts,
            onReactionTap: (eventId) {},
            onMoreReactionsTap: () {},
            onZapTap: (eventId) {},
            onMoreZapsTap: () {},
            onReportTap: () {},
            onAddProfileTap: () {},
            onOpenWithTap: () {},
            onLabelTap: () {},
            onShareTap: () {},
          ),
        );
      },
    ),
    // Add new settings route
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) {
        return AppSlideInScreen(
          child: Consumer(
            builder: (context, ref, _) {
              final pstate = ref.watch(query(kinds: {0}));
              final currentProfile = pstate.models.first as Profile;

              return AppSettingsScreen(
                currentNpub: currentProfile.npub,
                profiles: List.castFrom(pstate.models),
                onSelect: (profile) {
                  // TODO
                  // ref
                  //     .read(currentProfileProvider.notifier)
                  //     .setCurrentProfile(profile);
                },
                onHomeTap: () => context.pop(),
                onHistoryTap: () => context.push('/settings/history'),
                historyDescription: 'Last activity 12m ago',
                onDraftsTap: () => context.push('/settings/drafts'),
                draftsDescription: '21 Drafts',
                onLabelsTap: () => context.push('/settings/labels'),
                labelsDescription: '21 Public, 34 Private',
                onAppearanceTap: () => context.push('/settings/appearance'),
                appearanceDescription: 'Dark theme, Normal text',
                onHostingTap: () => context.push('/settings/hosting'),
                hostingDescription: '21 GB on 3 Relays, 2 Servers',
                onSecurityTap: () => context.push('/settings/security'),
                securityDescription: 'Secure mode, Keys are backed up',
                onOtherDevicesTap: () =>
                    context.push('/settings/other-devices'),
                otherDevicesDescription: 'Last activity 12m ago',
                onInviteTap: () => context.push('/settings/invite'),
                onDisconnectTap: () => context.push('/settings/disconnect'),
              );
            },
          ),
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
      path: '/settings/history',
      pageBuilder: (context, state) {
        return AppSlideInScreen(
          child: Consumer(
            builder: (context, ref, _) {
              final currentProfile = ref.watch(currentProfileProvider);
              return AppSettingsScreen(
                currentNpub: currentProfile.npub,
                profiles: dummyProfilesInUse,
                onSelect: (profile) {
                  ref
                      .read(currentProfileProvider.notifier)
                      .setCurrentProfile(profile);
                },
                onHomeTap: () => context.pop(),
                onHistoryTap: () => context.push('/settings/history'),
                historyDescription: 'Last activity 12m ago',
                onDraftsTap: () => context.push('/settings/drafts'),
                draftsDescription: '21 Drafts',
                onLabelsTap: () => context.push('/settings/labels'),
                labelsDescription: '21 Public, 34 Private',
                onAppearanceTap: () => context.push('/settings/appearance'),
                appearanceDescription: 'Dark theme, Normal text',
                onHostingTap: () => context.push('/settings/hosting'),
                hostingDescription: '21 GB on 3 Relays, 2 Servers',
                onSecurityTap: () => context.push('/settings/security'),
                securityDescription: 'Secure mode, Keys are backed up',
                onOtherDevicesTap: () =>
                    context.push('/settings/other-devices'),
                otherDevicesDescription: 'Last activity 12m ago',
                onInviteTap: () => context.push('/settings/invite'),
                onDisconnectTap: () => context.push('/settings/disconnect'),
              );
            },
          ),
        );
      },
    ),
    // TODO: Implement content screen
  ],
);
