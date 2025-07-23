import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rideshare/modules/home/screens/home_page.dart';
import 'package:rideshare/providers/auth/auth_provider.dart';
import 'package:rideshare/screens/sign_in_page.dart';
import 'package:rideshare/modules/rides/screens/rides_screen.dart';
import 'package:rideshare/modules/inbox/screens/inbox_screen.dart';
import 'package:rideshare/modules/profile/screens/profile_screen.dart';
import 'package:rideshare/shared/widgets/main_app.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    redirect: (context, state) {
      final isAuthenticated = authState.when(
        data: (state) => state.isAuthenticated,
        loading: () => false,
        error: (_, __) => false,
      );

      if (!isAuthenticated) {
        return '/';
      }

      if (isAuthenticated && state.matchedLocation == '/') {
        return '/home';
      }
      return null;
    },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SignInPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, child) => MainApp(child: child),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/rides',
              builder: (context, state) => const RidesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/inbox',
              builder: (context, state) => const InboxScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
  );
});
