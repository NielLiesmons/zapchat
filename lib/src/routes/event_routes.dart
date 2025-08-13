import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';
import '../providers/resolvers.dart';
import '../providers/search.dart';
import '../screens/thread_screen.dart';
import '../screens/article_screen.dart';
import '../screens/mail_screen.dart';
import '../screens/service_screen.dart';
import '../modals & bottom bars/reply_to_modal.dart';
import '../modals & bottom bars/actions_modal.dart';
import '../modals & bottom bars/label_modal.dart';
import '../modals & bottom bars/reply_modal.dart';
import '../modals & bottom bars/share_modal.dart';

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
        path: '/nostr-publication/:eventId',
        redirect: (context, state) {
          // If a model is provided, redirect to the appropriate route
          if (state.extra != null) {
            final model = state.extra as Model;
            final route = getModelRoute(model.runtimeType.toString());
            return '$route/${state.pathParameters['eventId']}';
          }
          // If no model is provided, return null to use the pageBuilder
          return null;
        },
        pageBuilder: (context, state) {
          // Show the default nostr publication view
          return LabSlideInScreen(
            context: context,
            child: Consumer(
              builder: (context, ref, _) {
                return LabText.h1(
                    'Nostr publication ${state.pathParameters['eventId']}');
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/actions/:eventId',
        pageBuilder: (context, state) {
          final extra = state.extra as ({
            Model model,
            Community? community,
            Function(Model)? onLocalReply
          });
          return LabSlideInModal(
            context: context,
            child: Consumer(
              builder: (context, ref, _) {
                return ActionsModal(
                  model: extra.model,
                  community: extra.community,
                  onLocalReply: extra.onLocalReply,
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
          return LabSlideInModal(
            context: context,
            child: Consumer(
              builder: (context, ref, _) {
                return LabZapModal(
                  model: model,
                  otherZaps: [],
                  recentAmounts: LabDefaultData.defaultAmounts,
                  onResolveEvent: ref.read(resolversProvider).eventResolver,
                  onResolveProfile: ref.read(resolversProvider).profileResolver,
                  onResolveEmoji: ref.read(resolversProvider).emojiResolver,
                  onSearchProfiles: ref.read(searchProvider).profileSearch,
                  onSearchEmojis: ref.read(searchProvider).emojiSearch,
                  onCameraTap: () {},
                  onEmojiTap: () {},
                  onGifTap: () {},
                  onAddTap: () {},
                  onProfileTap: (profile) =>
                      context.push('/profile/${profile.npub}', extra: profile),
                );
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/reply-to/:eventId',
        pageBuilder: (context, state) {
          final replyData =
              state.extra as ({Model model, Community? community});
          return LabPopInModal(
            context: context,
            child: Consumer(
              builder: (context, ref, _) {
                return ReplyToModal(
                  model: replyData.model,
                  community: replyData.community,
                );
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/label/:eventId',
        pageBuilder: (context, state) {
          final model = state.extra as Model;
          return LabSlideInModal(
            context: context,
            child: Consumer(
              builder: (context, ref, _) {
                return LabelModal(
                  model: model,
                );
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/share/:eventId',
        pageBuilder: (context, state) {
          final model = state.extra as Model;
          return LabSlideInModal(
            context: context,
            child: Consumer(
              builder: (context, ref, _) {
                return ShareModal(
                  model: model,
                );
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/reply/:eventId',
        pageBuilder: (context, state) {
          final model = state.extra as Model;
          return LabSlideInModal(
            context: context,
            child: Consumer(
              builder: (context, ref, _) {
                return ReplyModal(
                  reply: model as Comment,
                );
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/article/:eventId',
        pageBuilder: (context, state) {
          final model = state.extra as Model;
          return LabSlideInScreen(
            context: context,
            child: Consumer(
              builder: (context, ref, _) {
                return ArticleScreen(
                  article: model as Article,
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
          return LabSlideInScreen(
            context: context,
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
        path: '/service/:eventId',
        pageBuilder: (context, state) {
          final model = state.extra as Model;
          return LabSlideInScreen(
            context: context,
            child: Consumer(
              builder: (context, ref, _) {
                return ServiceScreen(
                  service: model as Service,
                );
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/thread/:eventId',
        pageBuilder: (context, state) {
          final model = state.extra as Model;
          return LabSlideInScreen(
            context: context,
            child: Consumer(
              builder: (context, ref, _) {
                return ThreadScreen(
                  thread: model as Note,
                );
              },
            ),
          );
        },
      ),
    ];
