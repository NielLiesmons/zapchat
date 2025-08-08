import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import '../screens/settings_screen.dart';
import '../modals & bottom bars/settings_preferences_modal.dart';
import '../modals & bottom bars/start_add_existing_key_modal.dart';
import '../modals & bottom bars/settings_add_profile_modal.dart';
import '../modals & bottom bars/settings_history_modal.dart';
import '../modals & bottom bars/settings_hosting_modal.dart';
import '../modals & bottom bars/start_your_key_modal.dart';
import '../modals & bottom bars/spin_up_key_modal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

List<GoRoute> get settingsRoutes => [
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) {
          return LabSlideInScreen(
            child: const SettingsScreen(),
          );
        },
      ),
      GoRoute(
        path: '/settings/add-profile',
        pageBuilder: (context, state) {
          return LabSlideInModal(
            child: SettingsAddProfileModal(
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
          return LabSlideInModal(
            child: SpinUpKeyModal(
              profileName: profileName,
              onSpinComplete: (secretKey, profileName) {
                context.push('/settings/your-key', extra: {
                  'secretKey': secretKey,
                  'profileName': profileName,
                });
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/settings/your-key',
        pageBuilder: (context, state) {
          return LabSlideInModal(
            child: Consumer(
              builder: (context, ref, child) {
                final extra = state.extra as Map<String, dynamic>;
                return StartYourKeyModal(
                  secretKey: extra['secretKey'] as String,
                  profileName: extra['profileName'] as String,
                );
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/settings/existing-profile',
        pageBuilder: (context, state) {
          return LabSlideInModal(
            child: StartAddExistingKeyModal(),
          );
        },
      ),
      GoRoute(
        path: '/settings/history',
        pageBuilder: (context, state) {
          return LabSlideInModal(
            child: const SettingsHistoryModal(),
          );
        },
      ),
      GoRoute(
        path: '/settings/appearance',
        pageBuilder: (context, state) {
          return LabSlideInModal(
            child: const PreferencesModal(),
          );
        },
      ),
      GoRoute(
        path: '/settings/hosting',
        pageBuilder: (context, state) {
          return LabSlideInModal(
            child: const SettingsHostingModal(),
          );
        },
      ),
    ];
