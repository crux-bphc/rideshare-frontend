import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/providers/auth/auth_user.dart';
import 'package:rideshare/providers/auth/logto_auth.dart';
import 'package:rideshare/shared/providers/user_provider.dart';

abstract class AuthProvider {
  Dio get dioClient;
  Future<AuthUser?> initialise();
  Future<AuthUser?> login();
  Future<void> logout();

  /// OIDC ID token for in-app profile claims only — not for backend API Authorization.
  Future<String?> get idToken;

  /// Resource access token for `Authorization: Bearer` on backend API requests.
  Future<String?> getAccessTokenForApi();
  void dispose();
}

class AuthState {
  final AuthUser? user;
  final bool isAuthenticated;
  final bool needsPhoneNumber;
  final bool isLoggingIn;

  AuthState({
    this.user,
    this.isAuthenticated = false,
    this.needsPhoneNumber = false,
    this.isLoggingIn = false,
  });

  AuthState copyWith({
    AuthUser? user,
    bool? isAuthenticated,
    bool? needsPhoneNumber,
    bool? isLoggingIn,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      needsPhoneNumber: needsPhoneNumber ?? this.needsPhoneNumber,
      isLoggingIn: isLoggingIn ?? this.isLoggingIn,
    );
  }

  bool get isUserLoadedForApi {
    final email = user?.email;
    return isAuthenticated && email != null && email.isNotEmpty;
  }
}

bool authReadyForUserApi(AsyncValue<AuthState> authState) {
  if (authState.isLoading) return false;
  final authValue = authState.valueOrNull;
  return authValue?.isUserLoadedForApi == true &&
      authValue?.needsPhoneNumber == false;
}

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    print('[Auth] AuthNotifier.build() - Initializing auth state');
    final authProvider = ref.read(logtoAuthProvider);
    try {
      final user = await authProvider.initialise();
      print(
        '[Auth] AuthNotifier.build() - Initialization complete, user: ${user != null ? "present" : "null"}',
      );
      return AuthState(user: user, isAuthenticated: user != null);
    } catch (e) {
      print('[Auth] ERROR in build: $e');
      rethrow;
    }
  }

  Future<void> login() async {
    print('[Auth] Login initiated');
    final current = state.valueOrNull ?? AuthState();
    state = AsyncValue.data(current.copyWith(isLoggingIn: true));

    try {
      final authProvider = ref.read(logtoAuthProvider);
      final user = await authProvider.login();
      print(
        '[Auth] AuthNotifier.login() - User returned: ${user != null ? "present (${user.name})" : "null"}',
      );

      state = AsyncValue.data(
        AuthState(
          user: user,
          isAuthenticated: user != null,
          needsPhoneNumber: false,
          isLoggingIn: false,
        ),
      );
    } catch (e) {
      print('[Auth] ERROR in login: $e');
      state = AsyncValue.data(current.copyWith(isLoggingIn: false));
    }
  }

  Future<void> checkNeedsRegistration() async {
    final currentState = state.valueOrNull;
    if (currentState == null || !currentState.isAuthenticated) return;

    if (currentState.user?.email == null) {
      print('[Auth] checkNeedsRegistration - no email in token');
      return;
    }

    try {
      final profile = await ref.read(profileUserDetailsProvider.future);
      print(
        '[Auth] checkNeedsRegistration - profile loaded: ${profile != null}',
      );

      if (profile == null) {
        state = AsyncValue.data(
          currentState.copyWith(
            needsPhoneNumber: true,
          ),
        );
      }
    } catch (e) {
      print('[Auth] ERROR in checkNeedsRegistration: $e');
    }
  }

  Future<void> logout() async {
    print('[Auth] Logout initiated');
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authProvider = ref.read(logtoAuthProvider);
      await authProvider.logout();
      print('[Auth] AuthNotifier.logout() - Logout successful');
      return AuthState(user: null, isAuthenticated: false);
    });
  }

  Future<void> completeNewUserRegistration(
    String phoneNumber,
    AuthUser user,
  ) async {
    final userService = ref.read(userServiceProvider);
    await userService.createUser(phoneNumber, user.name!);
    ref.invalidate(profileUserDetailsProvider);
    state = AsyncValue.data(
      AuthState(user: user, isAuthenticated: true, needsPhoneNumber: false),
    );
  }
}

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  () => AuthNotifier(),
);
