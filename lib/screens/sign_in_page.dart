import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../providers/auth/auth_provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1E2128),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "RideShare",
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 50),
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
              : OutlinedButton.icon(
            icon: const Icon(Icons.login_rounded),
            onPressed: () {
              GetIt.instance<AuthProvider>().login();
            },
            label: const Text('Sign in with Google'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFEBCB8B),
              side: const BorderSide(color: Color(0xFFEBCB8B)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
        );
      },
    );
  }
}