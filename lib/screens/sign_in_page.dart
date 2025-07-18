import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

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

class _LoginWidget extends StatelessWidget {
  const _LoginWidget();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetIt.instance.allReady(),
      builder: (context, snapshot) {
        final isReady = snapshot.connectionState == ConnectionState.done;
        final isLoading = !isReady || GetIt.instance<AuthProvider>().isLoggedIn.watch(context);
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : ElevatedButton.icon(
                  onPressed: () {
                    GetIt.instance<AuthProvider>().login();
                  },
                  label: const Text('Sign in with Google'),
                  icon: Icon(
                    Icons.login_rounded,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
        );
      },
    );
  }
}