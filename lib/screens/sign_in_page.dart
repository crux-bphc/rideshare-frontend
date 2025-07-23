import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/providers/auth/logto_auth.dart';
import '../providers/auth/auth_provider.dart';
import '../shared/theme.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
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
            // const SizedBox(height: 24),
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
    final isAuthenticated = authState.hasValue && (authState.value?.isAuthenticated ?? false);
    
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : isAuthenticated
              ? const SizedBox.shrink() // Hide button if already authenticated
              : ElevatedButton.icon(
                  onPressed: () async {
                    final authProvider = ref.read(logtoAuthProvider);
                    final authNotifier = ref.read(authNotifierProvider.notifier);
                    final authUser = await authProvider.login();
                    authNotifier.setUser(authUser);
                  },
                  label: const Text('Sign in with Google'),
                  icon: const Icon(
                    Icons.login_rounded,
                    color: Colors.white,
                  ),
                ),
    );
  }
}
