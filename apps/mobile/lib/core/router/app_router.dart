import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'route_paths.dart';

final routerProvider = Provider<GoRouter>((Ref ref) {
  return GoRouter(
    initialLocation: RoutePaths.splash,
    routes: <RouteBase>[
      GoRoute(
        path: RoutePaths.splash,
        builder: (BuildContext context, GoRouterState state) {
          return const Scaffold(body: Center(child: Text('Splash Screen')));
        },
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        builder: (BuildContext context, GoRouterState state) {
          return const Scaffold(body: Center(child: Text('Onboarding Screen')));
        },
      ),
      GoRoute(
        path: RoutePaths.auth,
        builder: (BuildContext context, GoRouterState state) {
          return const Scaffold(body: Center(child: Text('Auth Screen')));
        },
      ),
      GoRoute(
        path: RoutePaths.search,
        builder: (BuildContext context, GoRouterState state) {
          return const Scaffold(body: Center(child: Text('Search Screen')));
        },
      ),
      GoRoute(
        path: RoutePaths.report,
        builder: (BuildContext context, GoRouterState state) {
          return const Scaffold(body: Center(child: Text('Report Screen')));
        },
      ),
      GoRoute(
        path: RoutePaths.messages,
        builder: (BuildContext context, GoRouterState state) {
          return const Scaffold(body: Center(child: Text('Messages Screen')));
        },
      ),
      GoRoute(
        path: RoutePaths.alerts,
        builder: (BuildContext context, GoRouterState state) {
          return const Scaffold(body: Center(child: Text('Alerts Screen')));
        },
      ),
      GoRoute(
        path: RoutePaths.profile,
        builder: (BuildContext context, GoRouterState state) {
          return const Scaffold(body: Center(child: Text('Profile Screen')));
        },
      ),
    ],
  );
});
