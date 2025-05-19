import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:zapchat/src/modals/start_add_existing_key_modal.dart';
import 'package:zapchat/src/modals/start_paste_key._modal.dart';

List<GoRoute> get startRoutes => [
      GoRoute(
        path: '/start',
        pageBuilder: (context, state) {
          return AppSlideInModal(
            child: AppStartModal(
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
          return AppSlideInModal(
            child: AppSpinUpKeyModal(
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
          final extra = state.extra as Map<String, dynamic>;
          return AppSlideInModal(
            child: AppYourKeyModal(
              secretKey: extra['secretKey'] as String,
              profileName: extra['profileName'] as String,
              onUseThisKey: () {
                context.replace('/start/spin-up-key');
              },
              onUSpinAgain: () {
                context.pop();
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/start/existing-profile',
        pageBuilder: (context, state) {
          return AppSlideInModal(
            child: StartAddExistingKeyModal(),
          );
        },
      ),
      GoRoute(
        path: '/start/paste-key',
        pageBuilder: (context, state) {
          return AppSlideInModal(
            child: AppPasteKeyModal(
              onUseThisKey: () {
                context.pop(); // TODO: Add logic to use the key
              },
            ),
          );
        },
      ),
    ];
