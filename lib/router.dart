import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:rideshare/providers/auth/auth_provider.dart';
import 'package:rideshare/screens/home_page.dart';
import 'package:rideshare/screens/sign_in_page.dart';

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
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
  ],
);
