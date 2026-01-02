import 'package:flutter/foundation.dart';
import 'package:rideshare/models/ride.dart';
import 'package:rideshare/models/ride_request.dart';
import 'package:rideshare/models/user.dart';
import 'package:rideshare/providers/auth/auth_provider.dart';
import 'package:rideshare/providers/auth/logto_auth.dart';
import 'package:rideshare/shared/providers/rides_provider.dart';
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

  Future<User> getUser(String email) async {
    final userService = ref.watch(userServiceProvider);
    return userService.getUserDetails(email);
  }

  Future<String?> getUserEmail() async {
    final userService = ref.watch(userServiceProvider);
    return userService.getUserEmail();
  }

  Future<List<RideRequest>> getRequestsReceived() async {
    final userService = ref.watch(userServiceProvider);
    return userService.getRequestsReceived();
  }

  Future<List<RideRequest>> getSentRequests() async {
    final userService = ref.watch(userServiceProvider);
    return userService.getRequestsSent();
  }
}

@Riverpod(keepAlive: true)
Future<User?> profileUserDetails(ProfileUserDetailsRef ref) async {
  final authState = ref.watch(authNotifierProvider);
  if (authState.value?.user?.email != null) {
    try {
      return await ref
          .read(userServiceProvider)
          .getUserDetails(authState.value!.user!.email!);
    } catch (e) {
      debugPrint('Error fetching user details: $e');
      return null;
    }
  }
  return null;
}

@Riverpod(keepAlive: true)
class ProfilePastRides extends _$ProfilePastRides {
  @override
  Future<List<Ride>> build() async {
    try {
      final rideService = ref.read(rideServiceProvider);
      final completedRides = await rideService.getCompletedRides();
      completedRides.sort(
        (a, b) => DateTime.parse(
          b.departureEndTime.toString(),
        ).compareTo(DateTime.parse(a.departureEndTime.toString())),
      );
      return completedRides.take(5).toList();
    } catch (e) {
      debugPrint('Error fetching completed rides: $e');
      return [];
    }
  }
}
