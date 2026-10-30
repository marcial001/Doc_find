import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/listing_detail/presentation/screens/listing_detail_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/shell/presentation/screens/shell_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../widgets/app_bottom_nav.dart';
import 'route_paths.dart';

final routerProvider = Provider<GoRouter>((Ref ref) {
  final AuthState authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: RoutePaths.splash,
    redirect: (BuildContext context, GoRouterState state) {
      final String loc = state.matchedLocation;
      final bool isPublicRoute =
          loc == RoutePaths.splash ||
          loc == RoutePaths.onboarding ||
          loc == RoutePaths.auth;

      // If user is not authenticated and trying to access private routes, redirect to /auth
      if (!authState.isAuthenticated && !isPublicRoute) {
        return RoutePaths.auth;
      }

      // If user is already authenticated and on /auth, redirect to /search
      if (authState.isAuthenticated && loc == RoutePaths.auth) {
        return RoutePaths.search;
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: RoutePaths.splash,
        builder: (BuildContext context, GoRouterState state) =>
            const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        builder: (BuildContext context, GoRouterState state) =>
            const OnboardingScreen(),
      ),
      GoRoute(
        path: RoutePaths.auth,
        builder: (BuildContext context, GoRouterState state) =>
            const AuthScreen(),
      ),
      // App Shell Routes
      GoRoute(
        path: RoutePaths.search,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const NoTransitionPage<void>(
            child: ShellScreen(
              currentTab: NavTab.search,
              child: SearchScreen(),
            ),
          );
        },
      ),
      GoRoute(
        path: RoutePaths.detail,
        builder: (BuildContext context, GoRouterState state) {
          final int id = int.tryParse(state.pathParameters['id'] ?? '') ?? 1;
          return ListingDetailScreen(listingId: id);
        },
      ),
      GoRoute(
        path: RoutePaths.report,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const NoTransitionPage<void>(
            child: ShellScreen(
              currentTab: NavTab.report,
              child: Center(child: Text('Report Feature')),
            ),
          );
        },
      ),
      GoRoute(
        path: RoutePaths.messages,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const NoTransitionPage<void>(
            child: ShellScreen(
              currentTab: NavTab.messages,
              child: Center(child: Text('Messages Feature')),
            ),
          );
        },
      ),
      GoRoute(
        path: RoutePaths.alerts,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const NoTransitionPage<void>(
            child: ShellScreen(
              currentTab: NavTab.alerts,
              child: Center(child: Text('Alerts Feature')),
            ),
          );
        },
      ),
      GoRoute(
        path: RoutePaths.profile,
        builder: (BuildContext context, GoRouterState state) {
          return const Scaffold(body: Center(child: Text('Profile Feature')));
        },
      ),
    ],
  );
});
