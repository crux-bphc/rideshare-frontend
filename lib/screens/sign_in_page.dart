import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rideshare/shared/theme.dart';
import 'package:rideshare/widgets/custom_elevated_button.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../providers/auth/auth_provider.dart';

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

class _LoginWidget extends StatelessWidget {
  const _LoginWidget();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetIt.instance.allReady(),
      builder: (context, snapshot) {
        final isReady = snapshot.connectionState == ConnectionState.done;
        final isLoading =
            !isReady ||
            GetIt.instance<AuthProvider>().isLoggedIn.watch(context);
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : CustomElevatedButton(
                  onPressed: () {
                    GetIt.instance<AuthProvider>().login();
                  },
                  text: 'Sign in with Google',
                  icon: const Icon(
                    Icons.login_rounded,
                    color: Colors.white,
                  ),
                ),
        );
      },
    );
  }
}
