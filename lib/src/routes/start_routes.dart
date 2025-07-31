import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import '../modals/start_modal.dart';
import '../modals/start_add_existing_key_modal.dart';
import '../modals/start_paste_key_modal.dart';
import '../modals/start_your_key_modal.dart';
import '../modals/spin_up_key_modal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

List<GoRoute> get startRoutes => [
      GoRoute(
        path: '/start',
        pageBuilder: (context, state) {
          return LabSlideInModal(
            child: StartModal(
              logoImageUrl: 'assets/images/Zapchat-Blurple-Transparent.png',
              title: 'Zapchat',
              description: "Chat & Other Stuff",
              onStart: (profileName) {
                context.replace('/start/spin-up-key', extra: profileName);
              },
              onAlreadyHaveKey: () {
                context.replace('/start/existing-profile');
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/start/spin-up-key',
        pageBuilder: (context, state) {
          final profileName = state.extra as String;
          return LabSlideInModal(
            child: SpinUpKeyModal(
              profileName: profileName,
              onSpinComplete: (secretKey, profileName) {
                context.push('/start/your-key', extra: {
                  'secretKey': secretKey,
                  'profileName': profileName,
                });
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/start/your-key',
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
        path: '/start/existing-profile',
        pageBuilder: (context, state) {
          return LabSlideInModal(
            child: StartAddExistingKeyModal(),
          );
        },
      ),
      GoRoute(
        path: '/start/paste-key',
        pageBuilder: (context, state) {
          return LabSlideInModal(
            child: StartPasteKeyModal(),
          );
        },
      ),
    ];
