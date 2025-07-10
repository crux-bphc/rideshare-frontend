import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rideshare_frontend/providers/auth/auth_provider.dart';
import 'package:rideshare_frontend/providers/auth/oidc_auth.dart';
import 'package:rideshare_frontend/router.dart';

void main() async {
  await _prelaunchTasks();
  runApp(const MyApp());
}

Future<void> _prelaunchTasks() async {
  WidgetsFlutterBinding.ensureInitialized();
  final getIt = GetIt.instance;

  getIt.registerSingletonAsync<AuthProvider>(
        () async {
      final auth = OidcAuthProvider();
      await auth.initialise();
      return auth;
    },
    dispose: (auth) => auth.dispose(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _AppState();
}

class _AppState extends State<MyApp> {
  final getIt = GetIt.instance;
  void Function()? _dispose;

  @override
  void initState() {
    super.initState();
    _getItReady();
  }

  void _getItReady() async {
    await getIt.allReady();

    if (!mounted) return;
    final isLoggedIn = getIt<AuthProvider>().isLoggedIn;
    _dispose = isLoggedIn.subscribe((_) {
      router.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: "RideShare",
      theme: ThemeData.dark(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _dispose?.call();
  }
}