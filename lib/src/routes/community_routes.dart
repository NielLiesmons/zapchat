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
        builder: (context, state) {
          final community = state.extra as Community;
          // ✅ TEST: Direct navigation without LabSlideInScreen
          return CommunityScreen(community: community);
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
          final community = state.extra as Community;
          final contentType = state.pathParameters['contentType']?.capitalize();
          return CommunityScreen(
            community: community,
            initialContentType: contentType,
          );
        },
      ),
    ];
