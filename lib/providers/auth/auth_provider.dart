import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/providers/auth/auth_user.dart';
import 'package:rideshare/shared/providers/user_provider.dart';
import 'package:rideshare/providers/auth/logto_auth.dart';

abstract class AuthProvider {
  Dio get dioClient;
  Future<AuthUser?> initialise();
  Future<AuthUser?> login();
  Future<void> logout();

  Future<String?> get idToken;
  void dispose();
}

class AuthState {
  final AuthUser? user;
  final bool isAuthenticated;
  final bool needsPhoneNumber;

  AuthState({
    this.user,
    this.isAuthenticated = false,
    this.needsPhoneNumber = false,
  });

  AuthState copyWith({
    AuthUser? user,
    bool? isAuthenticated,
    bool? needsPhoneNumber,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      needsPhoneNumber: needsPhoneNumber ?? this.needsPhoneNumber,
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
      if (user != null) {
        final userService = ref.read(userServiceProvider);
        final userEmail= await userService.getUserEmail();
        if (userEmail == null) {
          return AuthState(
            user: user,
            isAuthenticated: false,
            needsPhoneNumber: true,
          );
        }
      }
      return AuthState(
        user: user,
        isAuthenticated: user != null ? true : false,
      );
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

  Future<void> completeNewUserRegistration(
    String phoneNumber,
    AuthUser user,
  ) async {
    final userService = ref.read(userServiceProvider);
    await userService.createUser(phoneNumber, user.name!);
    state = await AsyncValue.guard(() async {
      return AuthState(
        user: user,
        isAuthenticated: true,
        needsPhoneNumber: true,
      );
    });
  }

  Future<String?> getIdToken() async {
    final authProvider = ref.read(logtoAuthProvider);
    return await authProvider.idToken;
  }
}

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  () => AuthNotifier(),
);
