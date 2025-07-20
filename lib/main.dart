import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:rideshare/providers/auth/auth_provider.dart';
import 'package:rideshare/providers/auth/logto_auth.dart';
import 'package:rideshare/router.dart';
import 'package:rideshare/shared/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _prelaunchTasks();
  await GetIt.instance.allReady();
  runApp(const MyApp());
}

Future<void> _prelaunchTasks() async {
  final getIt = GetIt.instance;

  getIt.registerSingletonAsync<AuthProvider>(
    () async {
      final auth = LogtoAuthProvider();
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

  void _getItReady() {
    final isLoggedIn = getIt<AuthProvider>().isLoggedIn;
    _dispose = isLoggedIn.subscribe((_) {
      router.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        routerConfig: router,
        title: "RideShare",
        theme: appTheme,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _dispose?.call();
  }
}