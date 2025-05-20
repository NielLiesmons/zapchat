import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';
import '../modals/create_new_stuff_modal.dart';
import '../modals/create_message_modal.dart';
import '../screens/create_group_screen.dart';
import '../screens/create_community_screen.dart';

List<GoRoute> get createRoutes => [
      GoRoute(
        path: '/create',
        pageBuilder: (context, state) {
          return AppSlideInModal(
            child: CreateNewStuffModal(),
          );
        },
      ),
      GoRoute(
        path: '/create/group',
        pageBuilder: (context, state) {
          return AppSlideInScreen(
            child: CreateGroupScreen(),
          );
        },
      ),
      GoRoute(
        path: '/create/community',
        pageBuilder: (context, state) {
          return AppSlideInScreen(
            child: CreateCommunityScreen(),
          );
        },
      ),
      GoRoute(
        path: '/create/message',
        pageBuilder: (context, state) {
          final model = state.extra as Model;
          return AppSlideInModal(
            child: CreateMessageModal(target: model),
          );
        },
      ),
    ];
