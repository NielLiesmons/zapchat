import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';

List<GoRoute> get startRoutes => [
      GoRoute(
        path: '/start',
        pageBuilder: (context, state) {
          return AppSlideInModal(
            child: AppStartModal(
              logoImageUrl: 'assets/images/Zapchat-Blurple-Transparent.png',
              title: 'Welcome to Zapchat',
              onStart: (profileName) {
                context.replace('/start/spin-up-key', extra: profileName);
              },
              onAlreadyHaveKey: () {
                // Handle already have key case
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
                context.replace('/start/spin-up-key');
              },
            ),
          );
        },
      ),
    ];
