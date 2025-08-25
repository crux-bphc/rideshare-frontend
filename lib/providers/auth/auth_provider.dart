import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/providers/auth/auth_user.dart';
import 'package:rideshare/shared/providers/user_provider.dart';
import 'package:rideshare/providers/auth/logto_auth.dart';
import 'package:flutter/material.dart';
import 'package:rideshare/shared/widgets/phone_number_input_dialog.dart';

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

  Future<void> login(BuildContext context) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authProvider = ref.read(logtoAuthProvider);
      print("Attempting to login");
      final user = await authProvider.login();
      if (user != null) {
        final userService = ref.read(userServiceProvider);
        print("Checking if user exists: ${user.uid}");
        final userExists = await userService.checkUserExists();
        // final userExists = false;
        if (!userExists) {
          print("User does not exist, prompting for phone number");
          await completeNewUserRegistration('9667834455', user);
          // await showDialog(
          //   context: context,
          //   barrierDismissible: false,
          //   builder: (BuildContext dialogContext) {
          //     print("showing dialog");
          //     return PhoneNumberInputDialog(
          //       onSubmit: (phoneNumber) async {
          //         await completeNewUserRegistration(phoneNumber);
          //         Navigator.of(dialogContext).pop();
          //       },
          //     );
          //   },
          // );
        }
      }
      return AuthState(user: user, isAuthenticated: user != null ? true : false);
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

  Future<void> completeNewUserRegistration(String phoneNumber, AuthUser user) async {
    print("Completing new user registration with phone number: $phoneNumber");
    final userService = ref.read(userServiceProvider);
    // final user = state.value?.user;
    print("Current user: $user");
    // if(user == null) {
    //   print("No authenticated user found.");
    // }
    await userService.createUser(phoneNumber, user.name!);
    state = await AsyncValue.guard(() async {
      print("User created successfully with phone number: $phoneNumber");
      return AuthState(user: user, isAuthenticated: true);
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