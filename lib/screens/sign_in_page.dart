import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rideshare/shared/theme.dart';
import 'package:rideshare/widgets/custom_elevated_button.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../providers/auth/auth_provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignInPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
    _animation = Tween<double>(
      begin: 0.5,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
