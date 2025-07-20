import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rideshare/shared/theme.dart';
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
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.scale(scale: _animation.value, child: child);
              },
              child: Image.asset('assets/images/cab_icon.png', width: 200),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                "RIDE",
                style: TextStyle(
                  fontSize: 64,
                  color: AppColors.primary,
                  height: 1,
                  fontFamily: 'LemonMilk',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                "SHARE",
                style: TextStyle(
                  fontSize: 64,
                  color: AppColors.primary,
                  height: 1.2,
                  fontFamily: 'LemonMilk',
                ),
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
              : OutlinedButton.icon(
                  icon: Image.asset('assets/images/google_icon.png', width: 24),
                  onPressed: () {
                    GetIt.instance<AuthProvider>().login();
                  },
                  label: const Text(
                    'Sign in with Google',
                    style: TextStyle(fontFamily: 'Raleway'),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
        );
      },
    );
  }
}