import 'package:rideshare/models/user.dart';
import 'package:rideshare/providers/auth/logto_auth.dart';
import 'package:rideshare/shared/services/user_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

final userServiceProvider = Provider<UserService>((ref) {
  final dio = ref.watch(logtoAuthProvider).dioClient;
  return UserService(dio);
});

@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  Future<User?> build() async {
    return null;
  }

  Future<User> getUser(String email) async{
    final userService = ref.watch(userServiceProvider);
    return userService.getUserDetails(email);
  }

  Future<String?> getUserEmail() async{
    final userService = ref.watch(userServiceProvider);
    return  userService.getUserEmail();
  }
}
