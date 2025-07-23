import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/providers/auth/auth_provider.dart';
import 'package:rideshare/providers/auth/logto_auth.dart';
import 'package:rideshare/router.dart';
import 'package:rideshare/shared/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _AppState();
}

class _AppState extends ConsumerState<MyApp> {
  void Function()? _dispose;

  @override
  void initState() {
    super.initState();
    _initialiseAuth();
  }

  Future<void> _initialiseAuth() async {
    final authProvider = ref.read(logtoAuthProvider);
    final authUser = await authProvider.initialise();
    final authNotifier = ref.read(authNotifierProvider.notifier);
    authNotifier.setUser(authUser);
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      routerConfig: router,
      title: "RideShare",
      theme: appTheme,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _dispose?.call();
  }
}
