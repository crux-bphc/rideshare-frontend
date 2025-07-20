import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rideshare/providers/auth/auth_provider.dart';
import 'package:rideshare/screens/home_page.dart';
import 'package:rideshare/screens/sign_in_page.dart';

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
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
});

