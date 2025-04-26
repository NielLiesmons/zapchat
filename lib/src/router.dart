import 'package:go_router/go_router.dart';
import 'package:zapchat/src/homepage.dart';
import 'routes/create_routes.dart';
import 'routes/community_routes.dart';
import 'routes/event_routes.dart';
import 'routes/settings_routes.dart';
import 'routes/profile_routes.dart';

final goRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
    ),
    ...createRoutes,
    ...communityRoutes,
    ...eventRoutes,
    ...settingsRoutes,
    ...profileRoutes,
  ],
);
