import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/providers/auth/logto_auth.dart';
import '../providers/auth/auth_provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/logo.png',
              height: 150,
            ),
            // const SizedBox(height: 24),
            Text(
              'RideShare',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _LoginWidget(),
          ],
        ),
      ),
    );
  }
}

class _LoginWidget extends ConsumerWidget {
  const _LoginWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;
    final isAuthenticated = authState.hasValue && (authState.value?.isAuthenticated ?? false);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : isAuthenticated
              ? const SizedBox.shrink() // hide button if already authenticated
              : ElevatedButton.icon(
              onPressed: () async {
                     final authProvider = ref.read(logtoAuthProvider);
                     final authNotifier = ref.read(authNotifierProvider.notifier);
                     final authUser = await authProvider.login();
                     authNotifier.setUser(authUser);
                   },
              label: const Text('Sign in with Google'),
              icon: Icon(
                Icons.login_rounded,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
    );
  }
}