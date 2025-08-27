import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/providers/auth/auth_provider.dart';
import 'package:rideshare/shared/theme.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              height: 150,
            ),
            const SizedBox(height: 24),
            Text(
              'RideShare',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            const _LoginWidget(),
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

    final ButtonStyle baseButtonStyle = ElevatedButton.styleFrom(
      textStyle: Theme.of(context).textTheme.labelLarge,
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isLoading
          ? const Center(
              key: ValueKey('progress'),
              child: CircularProgressIndicator(),
            )
          : ElevatedButton.icon(
              key: const ValueKey('button'),
              onPressed: () async {
                ref.read(authNotifierProvider.notifier).login();
              },
              label: const Text('Sign in with Google'),
              icon: const Icon(
                Icons.login_rounded,
                color: Colors.white,
              ),
              style: baseButtonStyle,
            ),
    );
  }
}
