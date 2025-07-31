import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import '../screens/community_screen.dart';
import 'package:zaplab_design/zaplab_design.dart';
import '../modals/community_info_modal.dart';
import '../modals/community_pricing_modal.dart';
import '../modals/community_notifications_modal.dart';

List<GoRoute> get communityRoutes => [
      GoRoute(
        path: '/community/:npub',
        pageBuilder: (context, state) {
          final community = state.extra as Community;
          return LabSlideInScreen(
            child: CommunityScreen(community: community),
          );
        },
      ),
      GoRoute(
        path: '/community/:npub/info',
        pageBuilder: (context, state) {
          final community = state.extra as Community;
          return LabSlideInModal(
            child: CommunityInfoModal(community: community),
          );
        },
      ),
      GoRoute(
        path: '/community/:npub/info/pricing',
        pageBuilder: (context, state) {
          final community = state.extra as Community;
          return LabSlideInModal(
            child: CommunityPricingModal(community: community),
          );
        },
      ),
      GoRoute(
        path: '/community/:npub/notifications',
        pageBuilder: (context, state) {
          final community = state.extra as Community;
          return LabSlideInModal(
            child: CommunityNotificationsModal(community: community),
          );
        },
      ),
      GoRoute(
        path: '/community/:npub/:contentType',
        pageBuilder: (context, state) {
          final community = state.extra as Community;
          final contentType = state.pathParameters['contentType']?.capitalize();
          return LabSlideInScreen(
            child: CommunityScreen(
              community: community,
              initialContentType: contentType,
            ),
          );
        },
      ),
    ];
