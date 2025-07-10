import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:rideshare_frontend/providers/auth/auth_provider.dart';
import 'package:rideshare_frontend/screens/home_page.dart';
import 'package:rideshare_frontend/screens/sign_in_page.dart';

final router = GoRouter(
  redirect: (context, state) {
    final getIt = GetIt.instance;

    if (!getIt.allReadySync()) {
      return '/sign_in';
    }

    final isLoggedIn = getIt<AuthProvider>().isLoggedIn();

    if (!isLoggedIn) {
      return '/sign_in';
    }

    if (isLoggedIn && state.matchedLocation == '/sign_in') {
      return '/home';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/sign_in',
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
  ],
);