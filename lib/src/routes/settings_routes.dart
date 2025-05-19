import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:zapchat/src/screens/settings_screen.dart';
import 'package:zapchat/src/modals/preferences_modal.dart';
import 'package:zapchat/src/modals/start_add_existing_key_modal.dart';
import 'package:zapchat/src/modals/settings_history_modal.dart';

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
        path: '/settings/add-profile',
        pageBuilder: (context, state) {
          return AppSlideInModal(
            child: AppAddProfileModal(
              onStart: (profileName) {
                context.replace('/settings/spin-up-key', extra: profileName);
              },
              onAlreadyHaveKey: () {
                context.replace('/settings/existing-profile');
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/settings/spin-up-key',
        pageBuilder: (context, state) {
          final profileName = state.extra as String;
          return AppSlideInModal(
            child: AppSpinUpKeyModal(
              profileName: profileName,
              onSpinComplete: (secretKey, profileName) {
                context.replace('/settings/your-key', extra: {
                  'secretKey': secretKey,
                  'profileName': profileName,
                });
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/settings/existing-profile',
        pageBuilder: (context, state) {
          return AppSlideInModal(
            child: StartAddExistingKeyModal(),
          );
        },
      ),
      GoRoute(
        path: '/settings/history',
        pageBuilder: (context, state) {
          return AppSlideInModal(
            child: const SettingsHistoryModal(),
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
    ];
