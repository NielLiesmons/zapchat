import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:zapchat/src/providers/signed_in_profile.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'homepage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'modals/preferences_modal.dart';
import 'modals/community_info_modal.dart';
import 'modals/community_pricing_modal.dart';
import 'modals/community_notifications_modal.dart';

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
              // TODO: This data should not be loaded here, but in corresponding widgets

              final messagesState =
                  ref.watch(query(kinds: {9}, authors: {npub}));
              final notesState =
                  ref.watch(query(kinds: {1}, authors: {npub}, limit: 5));
              final profilesState = ref.watch(query(kinds: {0}));

              final articlesState =
                  ref.watch(query(kinds: {30023}, authors: {npub}));

              if (profilesState case StorageLoading()) {
                return Center(child: AppLoadingDots());
              }

              final profile = profilesState.models.first as Profile;

              return AppChatScreen(
                npub: npub,
                profileName: profile.nameOrNpub,
                profilePicUrl: profile.pictureUrl ?? '',
                onProfileTap: () => context.push('/chat/$npub/info'),
                messages: messagesState.models.cast(),
                posts: notesState.models.cast(),
                articles: articlesState.models.cast(),
                currentNpub: profile.npub,
                // TODO: This stuff should be derived from relationships
                mainCount: 21,
                contentCounts: {
                  'chat': messagesState.models.length,
                  'article': articlesState.models.length,
                  'post': notesState.models.length,
                },
                // Callbacks
                onHomeTap: () => context.pop(),
                onActions: (nevent) => context.push('/actions/$nevent'),
                onReply: (eventId) {},
                onReactionTap: (eventId) {},
                onZapTap: (eventId) {},
                onLinkTap: (url) {},
                onResolveEvent: (id) async {
                  final events = await ref.read(storageProvider).queryAsync(
                        RequestFilter(
                          kinds: {30023},
                          authors: {
                            'a9434ee165ed01b286becfc2771ef1705d3537d051b387288898cc00d5c885be'
                          },
                          limit: 1,
                        ),
                      );
                  return events.cast<Article>().first;
                },
                onResolveProfile: (id) async {
                  final profiles = await ref.read(storageProvider).queryAsync(
                        RequestFilter(
                          kinds: {0},
                          authors: {
                            'f683e87035f7ad4f44e0b98cfbd9537e16455a92cd38cefc4cb31db7557f5ef2'
                          },
                          limit: 1,
                        ),
                      );
                  return profiles.cast<Profile>().first;
                },
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
    GoRoute(
      path: '/chat/:npub/info',
      pageBuilder: (context, state) {
        final npub = state.pathParameters['npub']!;
        return AppSlideInModal(
          child: Consumer(
            builder: (context, ref, _) {
              final profileState =
                  ref.watch(query(kinds: {0}, authors: {npub}));

              if (profileState case StorageLoading()) {
                return Center(child: AppLoadingDots());
              }

              if (profileState.models.isEmpty) {
                return Center(
                  child: AppText.reg14(
                    'Profile not found',
                    color: AppTheme.of(context).colors.white66,
                  ),
                );
              }

              final profile = profileState.models.first as Profile;
              return CommunityInfoModal(
                profilePicUrl: profile.pictureUrl ?? '',
                title: profile.nameOrNpub,
                description:
                    '${profile.nameOrNpub} is a lorem ipsum and then some more info on this specific community that we are talking about here and although we are pretty sure we can come with better examples in the future this will have to dod for now',
                npub: npub,
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
          child: Consumer(
            builder: (context, ref, _) {
              return AppActionsModal(
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
                onResolveEvent: (id) async {
                  final events = await ref.read(storageProvider).queryAsync(
                        RequestFilter(
                          kinds: {30023},
                          authors: {
                            'a9434ee165ed01b286becfc2771ef1705d3537d051b387288898cc00d5c885be'
                          },
                          limit: 1,
                        ),
                      );
                  return events.cast<Article>().first;
                },
                onResolveProfile: (id) async {
                  final profiles = await ref.read(storageProvider).queryAsync(
                        RequestFilter(
                          kinds: {0},
                          authors: {
                            'f683e87035f7ad4f44e0b98cfbd9537e16455a92cd38cefc4cb31db7557f5ef2'
                          },
                          limit: 1,
                        ),
                      );
                  return profiles.cast<Profile>().first;
                },
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
              final currentProfile = ref.watch(signedInProfile);
              return AppSettingsScreen(
                currentNpub: currentProfile!.npub,
                profiles: [],
                onSelect: (profile) {
                  ref.read(signedInProfile.notifier).state = profile;
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
