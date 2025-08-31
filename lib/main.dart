import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/providers/auth/auth_provider.dart';
import 'package:rideshare/router.dart';
import 'package:rideshare/shared/providers/navigation_provider.dart';
import 'package:rideshare/shared/theme.dart';
import 'package:rideshare/modules/splash/splash_page.dart';
import 'package:rideshare/shared/widgets/phone_number_input_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<AuthState>>(authNotifierProvider, (previous, next) {
      ref.read(goRouterProvider).refresh();
      final wasLoading = previous?.isLoading ?? false;
      final needsPhoneNumber = next.valueOrNull?.needsPhoneNumber ?? false;

      if (wasLoading && needsPhoneNumber) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final currentContext = navigatorKey.currentContext;
          if (currentContext != null) {
            showDialog(
              context: currentContext,
              barrierDismissible: false,
              builder: (BuildContext dialogContext) {
                return PhoneNumberInputDialog(
                  onSubmit: (phoneNumber) {
                    final user = next.value!.user!;
                    ref
                        .read(authNotifierProvider.notifier)
                        .completeNewUserRegistration(phoneNumber, user);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.success,
                        content: Text('User registered successfully!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.of(dialogContext).pop();
                  },
                );
              },
            );
          }
        });
      }
    });

    final authState = ref.watch(authNotifierProvider);

    return authState.when(
      loading: () {
        return MaterialApp(
          home: const SplashPage(),
          theme: appTheme,
          debugShowCheckedModeBanner: false,
        );
      },
      error: (error, stackTrace) {
        final router = ref.watch(goRouterProvider);
        return MaterialApp.router(
          routerConfig: router,
          title: "RideShare",
          theme: appTheme,
          debugShowCheckedModeBanner: false,
        );
      },
      data: (initialAuthState) {
        final router = ref.watch(goRouterProvider);
        return MaterialApp.router(
          routerConfig: router,
          title: "RideShare",
          theme: appTheme,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
