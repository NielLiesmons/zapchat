import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';
import '../../screens/community_screen.dart';
import '../../modals/community_info_modal.dart';
import '../../modals/community_pricing_modal.dart';
import '../../modals/community_notifications_modal.dart';

List<GoRoute> get communityRoutes => [
      GoRoute(
        path: '/community/:npub',
        pageBuilder: (context, state) {
          final community = state.extra as Community;
          return AppSlideInScreen(
            child: CommunityScreen(community: community),
          );
        },
      ),
      GoRoute(
        path: '/chat/:npub/info',
        pageBuilder: (context, state) {
          final community = state.extra as Community;
          return AppSlideInModal(
            child: CommunityInfoModal(community: community),
          );
        },
      ),
      GoRoute(
        path: '/chat/:npub/info/pricing',
        pageBuilder: (context, state) {
          final community = state.extra as Community;
          return AppSlideInModal(
            child: CommunityPricingModal(community: community),
          );
        },
      ),
      GoRoute(
        path: '/chat/:npub/info/notifications',
        pageBuilder: (context, state) {
          final community = state.extra as Community;
          return AppSlideInModal(
            child: CommunityNotificationsModal(community: community),
          );
        },
      ),
    ];
