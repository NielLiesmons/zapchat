import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';
import '../modals/create_new_stuff_modal.dart';
import '../modals/create_message_modal.dart';
import '../modals/spin_up_community_key_modal.dart';
import '../screens/create_group_screen.dart';
import '../screens/create_community_screen.dart';
import '../screens/create_event_screen.dart';
import '../screens/create_mail_screen.dart';
import '../screens/create_task_screen.dart';
import '../screens/create_note_screen.dart';
import '../screens/your_community_screen.dart';
import '../modals/community_key_modal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

List<GoRoute> get createRoutes => [
      GoRoute(
        path: '/create',
        pageBuilder: (context, state) {
          return LabSlideInModal(
            child: CreateNewStuffModal(),
          );
        },
      ),
      GoRoute(
        path: '/create/group',
        pageBuilder: (context, state) {
          return LabSlideInScreen(
            child: CreateGroupScreen(),
          );
        },
      ),
      GoRoute(
        path: '/create/community',
        pageBuilder: (context, state) {
          return LabSlideInScreen(
            child: CreateCommunityScreen(),
          );
        },
      ),
      GoRoute(
        path: '/create/community/spin-up-community-key',
        pageBuilder: (context, state) {
          final profileName = state.extra as String;
          return LabSlideInModal(
            child: SpinUpCommunityKeyModal(
              profileName: profileName,
              onSpinComplete: (secretKey, profileName) {
                context.push('/create/community/your-community-key', extra: {
                  'secretKey': secretKey,
                  'profileName': profileName,
                });
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/create/community/your-community-key',
        pageBuilder: (context, state) {
          return LabSlideInModal(
            child: Consumer(
              builder: (context, ref, child) {
                final extra = state.extra as Map<String, dynamic>;
                return CommunityKeyModal(
                  secretKey: extra['secretKey'] as String,
                  profileName: extra['profileName'] as String,
                );
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/create/community/configure',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return LabSlideInScreen(
            child: YourCommunityScreen(
              profile: extra['profile'] as Profile,
              communityName: extra['communityName'] as String,
            ),
          );
        },
      ),
      GoRoute(
        path: '/create/event',
        pageBuilder: (context, state) {
          return LabSlideInScreen(
            child: CreateEventScreen(),
          );
        },
      ),
      GoRoute(
        path: '/create/mail',
        pageBuilder: (context, state) {
          return LabSlideInScreen(
            child: CreateMailScreen(),
          );
        },
      ),
      GoRoute(
        path: '/create/message',
        pageBuilder: (context, state) {
          final model = state.extra as Model;
          return LabSlideInModal(
            child: CreateMessageModal(target: model),
          );
        },
      ),
      GoRoute(
        path: '/create/note',
        pageBuilder: (context, state) {
          return LabSlideInScreen(
            child: CreateNoteScreen(),
          );
        },
      ),
      GoRoute(
        path: '/create/task',
        pageBuilder: (context, state) {
          return LabSlideInScreen(
            child: CreateTaskScreen(),
          );
        },
      ),
    ];
