import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/providers/auth/auth_provider.dart';
import 'package:rideshare/providers/auth/logto_auth.dart';
import 'package:rideshare/utils/router.dart';
import 'package:rideshare/utils/theme.dart';

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
    return MaterialApp.router(
      routerConfig: ref.watch(goRouterProvider),
      title: "RideShare",
      theme: appTheme,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}