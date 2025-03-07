import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'homepage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/messages.dart';
import 'providers/chat_screen.dart';
import 'providers/posts.dart';
import 'providers/articles.dart';
import 'providers/current_profile.dart';
import 'providers/dummy_data.dart';
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
              final posts = ref.watch(postsProvider.notifier).getPosts(npub);
              final articles =
                  ref.watch(articlesProvider.notifier).getArticles(npub);
              final profile = ref.watch(chatScreenDataProvider)[npub];
              final currentProfile = ref.watch(currentProfileProvider);

              return AppChatScreen(
                npub: npub,
                profileName: profile?.profileName ?? '',
                profilePicUrl: profile?.profilePicUrl ?? '',
                messages: messages,
                posts: posts,
                articles: articles,
                currentNpub: currentProfile.npub,
                mainCount: profile?.mainCount,
                contentCounts: profile?.contentCounts ?? {},
                onHomeTap: () => context.pop(),
                onActions: (nevent) => context.push('/actions/$nevent'),
                onReply: (eventId) {},
                onReactionTap: (eventId) {},
                onZapTap: (eventId) {},
                onLinkTap: (url) {},
                onResolveEvent: (id) async => throw UnimplementedError(),
                onResolveProfile: (id) async => throw UnimplementedError(),
                onResolveEmoji: (id) async => throw UnimplementedError(),
                onResolveHashtag: (id) async => throw UnimplementedError(),
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
    GoRoute(
      path: '/settings/appearance',
      pageBuilder: (context, state) {
        return AppSlideInModal(
          child: const PreferencesModal(),
        );
      },
    ),
    // TODO: Implement content screen
  ],
);
