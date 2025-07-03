import 'package:go_router/go_router.dart';
import 'homepage.dart';
import 'routes/create_routes.dart';
import 'routes/community_routes.dart';
import 'routes/event_routes.dart';
import 'routes/profile_routes.dart';
import 'routes/start_routes.dart';
import 'routes/settings_routes.dart';

final goRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return HomePage();
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
  ],
);
