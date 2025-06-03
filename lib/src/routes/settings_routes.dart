import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import '../screens/settings_screen.dart';
import '../modals/preferences_modal.dart';
import '../modals/start_add_existing_key_modal.dart';
import '../modals/settings_history_modal.dart';
import '../modals/settings_hosting_modal.dart';
import '../modals/start_your_key_modal.dart';
import '../modals/spin_up_key_modal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
            child: SpinUpKeyModal(
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
        path: '/settings/your-key',
        pageBuilder: (context, state) {
          return AppSlideInModal(
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
      GoRoute(
        path: '/settings/hosting',
        pageBuilder: (context, state) {
          return AppSlideInModal(
            child: const SettingsHostingModal(),
          );
        },
      ),
    ];
