import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/providers/auth/logto_auth.dart';
import 'package:rideshare/shared/services/user_service.dart';

final userServiceProvider = Provider<UserService>((ref) {
  final dio = ref.watch(logtoAuthProvider).dioClient;
  return UserService(dio);
});
