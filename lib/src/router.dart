import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'routes/create_routes.dart';
import 'routes/community_routes.dart';
import 'routes/event_routes.dart';
import 'routes/profile_routes.dart';
import 'routes/start_routes.dart';
import 'routes/settings_routes.dart';
import 'screens/simple_community_test.dart';

final goRouter = GoRouter(
  redirect: (context, state) {
    // Check if we're navigating to a modal/screen that should disable underlying pages
    final isModalRoute = state.matchedLocation.contains('/actions/') ||
        state.matchedLocation.contains('/zap/') ||
        state.matchedLocation.contains('/reply-to/') ||
        state.matchedLocation.contains('/label/') ||
        state.matchedLocation.contains('/share/') ||
        state.matchedLocation.contains('/reply/');

    final isScreenRoute = state.matchedLocation.contains('/article/') ||
        state.matchedLocation.contains('/mail/') ||
        state.matchedLocation.contains('/service/') ||
        state.matchedLocation.contains('/thread/') ||
        state.matchedLocation.contains('/nostr-publication/');

    // If navigating to a modal/screen, don't redirect (let it load)
    if (isModalRoute || isScreenRoute) {
      return null;
    }

    // For other routes, allow normal navigation
    return null;
  },
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
  ],
);
