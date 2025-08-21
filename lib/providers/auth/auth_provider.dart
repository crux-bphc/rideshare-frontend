import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/providers/auth/auth_user.dart';
import 'package:rideshare/providers/auth/logto_auth.dart';

abstract class AuthProvider {
  Dio get dioClient;
  Future<AuthUser?> initialise();
  Future<AuthUser?> login();
  Future<void> logout();

  Future<String?> getIdToken();
  void dispose();
}

class AuthState {
  final AuthUser? user;
  final bool isAuthenticated;

  AuthState({this.user, this.isAuthenticated = false});

  AuthState copyWith({
    AuthUser? user,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final authProvider = ref.read(logtoAuthProvider);
    final user = await authProvider.initialise();
    return AuthState(user: user, isAuthenticated: user != null);
  }

  Future<void> login() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authProvider = ref.read(logtoAuthProvider);
      final user = await authProvider.login();
      return AuthState(user: user, isAuthenticated: user != null);
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authProvider = ref.read(logtoAuthProvider);
      await authProvider.logout();
      return AuthState(user: null, isAuthenticated: false);
    });
  }

  Future<String?> getIdToken() async {
    final authProvider = ref.read(logtoAuthProvider);
    return await authProvider.getIdToken();
  }
}

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  () => AuthNotifier(),
);