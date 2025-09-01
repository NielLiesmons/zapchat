import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import '../screens/community_screen.dart';
import 'package:zaplab_design/zaplab_design.dart';
import '../modals & bottom bars/community_info_modal.dart';
import '../modals & bottom bars/community_pricing_modal.dart';
import '../modals & bottom bars/community_notifications_modal.dart';

List<GoRoute> get communityRoutes => [
      GoRoute(
        path: '/community/:npub',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final community = extra['community'] as Community;
          final activePubkey = extra['activePubkey'] as String?;
          return LabSlideInScreen(
            context: context,
            child: CommunityScreen(
              community: community,
              activePubkey: activePubkey,
            ),
          );
        },
      ),
      GoRoute(
        path: '/community/:npub/info',
        pageBuilder: (context, state) {
          final community = state.extra as Community;
          return LabSlideInModal(
            context: context,
            child: CommunityInfoModal(community: community),
          );
        },
      ),
      GoRoute(
        path: '/community/:npub/info/pricing',
        pageBuilder: (context, state) {
          final community = state.extra as Community;
          return LabSlideInModal(
            context: context,
            child: CommunityPricingModal(community: community),
          );
        },
      ),
      GoRoute(
        path: '/community/:npub/notifications',
        pageBuilder: (context, state) {
          final community = state.extra as Community;
          return LabSlideInModal(
            context: context,
            child: CommunityNotificationsModal(community: community),
          );
        },
      ),
      GoRoute(
        path: '/community/:npub/:contentType',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final community = extra['community'] as Community;
          final contentType = state.pathParameters['contentType']?.capitalize();
          final activePubkey = extra['activePubkey'] as String?;
          return CommunityScreen(
            community: community,
            initialContentType: contentType,
            activePubkey: activePubkey,
          );
        },
      ),
    ];
