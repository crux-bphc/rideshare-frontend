import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_user.dart';

abstract class AuthProvider {


  Dio get dioClient;

  /// To be called before the app is in a usable state
  Future<AuthUser?> initialise();

  Future<AuthUser?> login();

  Future<void> logout();

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
    return AuthState(isAuthenticated: false, user: null);
  }

  void setUser(AuthUser? user) {
    state = AsyncData(
      state.value!.copyWith(user: user, isAuthenticated: user != null),
    );
  }
}

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  () => AuthNotifier(),
);
