import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:rideshare/modules/home/screens/home_page.dart';
import 'package:rideshare/providers/auth/auth_provider.dart';
import 'package:rideshare/screens/sign_in_page.dart';
import 'package:rideshare/modules/rides/screens/rides_screen.dart';
import 'package:rideshare/modules/inbox/screens/inbox_screen.dart';
import 'package:rideshare/modules/profile/screens/profile_screen.dart';
import 'package:rideshare/shared/widgets/main_app.dart';

final router = GoRouter(
  redirect: (context, state) {
    final getIt = GetIt.instance;

    if (!getIt.allReadySync()) {
      return '/';
    }

    final isLoggedIn = getIt<AuthProvider>().isLoggedIn();

    if (!isLoggedIn) {
      return '/';
    }

    if (isLoggedIn && state.matchedLocation == '/') {
      return '/home';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SignInPage(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainApp(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/rides',
          builder: (context, state) => const RidesScreen(),
        ),
        GoRoute(
          path: '/inbox',
          builder: (context, state) => const InboxScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
