import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:zapchat/src/screens/settings_screen.dart';
import 'package:zapchat/src/modals/preferences_modal.dart';

List<GoRoute> get settingsRoutes => [
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) {
          return AppSlideInScreen(
            child: const SettingsScreen(),
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
        path: '/slotMachine',
        pageBuilder: (context, state) {
          final profileName = state.extra as String;
          return AppSlideInModal(
            child: AppSlotMachineModal(
              profileName: profileName,
            ),
          );
        },
      ),
      GoRoute(
        path: '/settings/get-started',
        pageBuilder: (context, state) {
          return AppSlideInModal(
            child: AppAddProfileModal(
              onStart: (profileName) {
                context.replace('/slotMachine', extra: profileName);
              },
              onAlreadyHaveKey: () {
                // Handle already have key case
              },
            ),
          );
        },
      ),
    ];
