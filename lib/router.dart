import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rideshare/modules/home/screens/home_page.dart';
import 'package:rideshare/modules/splash/splash_page.dart';
import 'package:rideshare/providers/auth/auth_provider.dart';
import 'package:rideshare/screens/sign_in_page.dart';
import 'package:rideshare/modules/rides/screens/rides_screen.dart';
import 'package:rideshare/modules/inbox/screens/inbox_screen.dart';
import 'package:rideshare/modules/profile/screens/profile_screen.dart';
import 'package:rideshare/shared/widgets/main_app.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final location = state.matchedLocation;

      if (authState.isLoading && location != '/splash') {
        return '/splash';
      }
      final isAuthenticated = authState.valueOrNull?.isAuthenticated ?? false;
      final isGoingToSplash = location == '/splash';
      final isGoingToLogin = location == '/';

      if (isAuthenticated) {
        if (isGoingToSplash || isGoingToLogin) {
          return '/home';
        }
      } else {
        if (!isGoingToLogin && !isGoingToSplash) {
          return '/';
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) {
          return _buildPageWithFadeTransition(
            path: state.matchedLocation,
            child: const SignInPage(),
          );
        },
      ),
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) {
          return _buildPageWithFadeTransition(
            path: state.matchedLocation,
            child: const SplashPage(),
          );
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, child) => MainApp(child: child),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) {
                  return _buildPageWithFadeTransition(
                    path: state.matchedLocation,
                    child: const HomePage(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/rides',
                pageBuilder: (context, state) {
                  return _buildPageWithFadeTransition(
                    path: state.matchedLocation,
                    child: const RidesScreen(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/inbox',
                pageBuilder: (context, state) {
                  return _buildPageWithFadeTransition(
                    path: state.matchedLocation,
                    child: const InboxScreen(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                pageBuilder: (context, state) {
                  return _buildPageWithFadeTransition(
                    path: state.matchedLocation,
                    child: const ProfileScreen(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

CustomTransitionPage<void> _buildPageWithFadeTransition({
  required String path,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: ValueKey(path),
    child: child,
    transitionsBuilder:
        (context, animation, secondaryAnimation, child) =>
        FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: child,
        ),
  );
}