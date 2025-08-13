import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'homepage.dart';
import 'routes/create_routes.dart';
import 'routes/community_routes.dart';
import 'routes/event_routes.dart';
import 'routes/profile_routes.dart';
import 'routes/start_routes.dart';
import 'routes/settings_routes.dart';
import 'screens/simple_community_test.dart';

final goRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return HomePage(
          tab: 'home',
        );
      },
    ),
    GoRoute(
      path: '/home/:tab',
      builder: (context, state) {
        return HomePage(
            tab: state.pathParameters['tab'] ??
                'home'); // TODO: enable routing to specific Tab
      },
    ),
    ...createRoutes,
    ...communityRoutes,
    ...eventRoutes,
    ...settingsRoutes,
    ...startRoutes,
    ...profileRoutes,
    GoRoute(
      path: '/simple-community-test',
      builder: (context, state) {
        final community = state.extra as Community;
        return SimpleCommunityTest();
      },
    ),
  ],
);
