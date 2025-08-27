import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/providers/auth/auth_provider.dart';
import 'package:rideshare/router.dart';
import 'package:rideshare/shared/theme.dart';
import 'package:rideshare/modules/splash/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authNotifierProvider, (_, __) {
      final router = ref.watch(goRouterProvider);
      router.refresh();
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
