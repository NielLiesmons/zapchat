import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';
import '../screens/profile_screen.dart';

List<GoRoute> get profileRoutes => [
      GoRoute(
        path: '/profile/:npub',
        pageBuilder: (context, state) {
          final profile = state.extra as Profile;
          return AppSlideInScreen(
            child: ProfileScreen(profile: profile),
          );
        },
      ),
    ];
