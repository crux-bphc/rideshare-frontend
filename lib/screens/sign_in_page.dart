import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/providers/auth/auth_provider.dart';
import 'package:rideshare/shared/theme.dart';
import 'package:rideshare/shared/widgets/phone_number_input_dialog.dart';

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

    ref.listen<AsyncValue<AuthState>>(authNotifierProvider, (previous, next) {
      if (next.value?.needsPhoneNumber == true && !next.isLoading) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return PhoneNumberInputDialog(
              onSubmit: (phoneNumber) async {
                await ref
                    .read(authNotifierProvider.notifier)
                    .completeNewUserRegistration(phoneNumber, next.value!.user!);
                Navigator.of(dialogContext).pop();
              },
            );
          },
        );
      }
    });

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
