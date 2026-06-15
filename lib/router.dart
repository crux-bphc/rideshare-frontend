import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rideshare/modules/home/screens/home_page.dart';
import 'package:rideshare/modules/rides/create_rides/create_ride_screen.dart';
import 'package:rideshare/modules/splash/splash_page.dart';
import 'package:rideshare/providers/auth/auth_provider.dart';
import 'package:rideshare/screens/sign_in_page.dart';
import 'package:rideshare/modules/inbox/screens/inbox_screen.dart';
import 'package:rideshare/modules/profile/screens/profile_screen.dart';
import 'package:rideshare/shared/providers/navigation_provider.dart';
import 'package:rideshare/shared/widgets/main_app.dart';
import 'package:rideshare/modules/rides/search_rides/search_rides_screen.dart';
import 'package:rideshare/modules/rides/available_rides/available_rides_screen.dart';
import 'package:rideshare/modules/rides/your_rides/your_rides_screen.dart';
import 'package:rideshare/modules/rides/ride_details/ride_details_screen.dart';
import 'package:rideshare/models/ride.dart';

bool _registrationCheckDone = false;

final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = RouterNotifier(ref);
  
  return GoRouter(
    navigatorKey: navigatorKey,
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final location = state.matchedLocation;
      final authValue = authState.valueOrNull;
      if (authState.isLoading && location != '/splash') {
        return '/splash';
      }

      final isAuthenticated = authValue?.isAuthenticated ?? false;
      final needsPhoneNumber = authValue?.needsPhoneNumber ?? false;
      final isLoggingIn = authValue?.isLoggingIn ?? false;
      final isGoingToSplash = location == '/splash';
      final isGoingToLogin = location == '/';
      if (isLoggingIn) return null;

      if (needsPhoneNumber) return '/register';

      if (isAuthenticated) {
        if (isGoingToSplash || isGoingToLogin) return '/home';
      } else {
        if (!isGoingToLogin && !isGoingToSplash) return '/';
      }

      if (authValue?.isUserLoadedForApi == true &&
          !needsPhoneNumber &&
          !_registrationCheckDone) {
        _registrationCheckDone = true;
        Future.microtask(() =>
          ref.read(authNotifierProvider.notifier).checkNeedsRegistration()
        );
      }

      if (!isAuthenticated) {
        _registrationCheckDone = false;
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
        builder: (context, state, navigationShell) {
          return MainApp(
            navigationShell: navigationShell,
            child: navigationShell,
          );
        },
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
                    child: const YourRidesScreen(),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'search',
                    pageBuilder: (context, state) {
                      return _buildPageWithFadeTransition(
                        path: state.matchedLocation,
                        child: const SearchRidesScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'available',
                    pageBuilder: (context, state) {
                      return _buildPageWithFadeTransition(
                        path: state.matchedLocation,
                        child: const AvailableRidesScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'create',
                    pageBuilder: (context, state) {
                      bool isEditing = false;
                      Ride? ride;
                      String? rideId;

                      if (state.extra != null &&
                          state.extra is Map<String, dynamic>) {
                        final params = state.extra as Map<String, dynamic>;
                        final isEditingValue = params['isEditing'];
                        if (isEditingValue is bool) {
                          isEditing = isEditingValue;
                        }
                        final rideValue = params['ride'];
                        if (rideValue is Ride) {
                          ride = rideValue;
                        }
                        final rideIdValue = params['rideId'];
                        if (rideIdValue is String) {
                          rideId = rideIdValue;
                        }
                      }

                      return _buildPageWithFadeTransition(
                        path: state.matchedLocation,
                        child: CreateRideScreen(
                          isEditing: isEditing,
                          ride: ride,
                          rideId: rideId,
                        ),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'details',
                    pageBuilder: (context, state) {
                      final ride = state.extra as Ride;
                      return _buildPageWithFadeTransition(
                        path: state.matchedLocation,
                        child: RideDetailsScreen(ride: ride),
                      );
                    },
                  ),
                ],
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

class RouterNotifier extends ChangeNotifier {
  RouterNotifier(this._ref) {
    _ref.listen(authNotifierProvider, (_, __) => notifyListeners());
  }
  final Ref _ref;
}

CustomTransitionPage<void> _buildPageWithFadeTransition({
  required String path,
  required Widget child,
  bool opaque = true,
}) {
  return CustomTransitionPage<void>(
    opaque: opaque,
    key: ValueKey(path),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: child,
        ),
  );
}
