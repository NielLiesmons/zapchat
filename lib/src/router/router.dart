import 'package:go_router/go_router.dart';
import 'package:zapchat/src/homepage.dart';
import 'routes/community_routes.dart';
import 'routes/event_routes.dart';
import 'routes/settings_routes.dart';

final goRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
    ),
    ...communityRoutes,
    ...eventRoutes,
    ...settingsRoutes,
  ],
);
