import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/models/user.dart';
import 'package:rideshare/providers/auth/logto_auth.dart';
import 'package:rideshare/models/ride.dart';
import 'package:rideshare/shared/services/ride_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rides_provider.g.dart';

final rideServiceProvider = Provider<RideService>((ref) {
  final dio = ref.watch(logtoAuthProvider).dioClient;
  return RideService(dio);
});

final isBookmarkingProvider = StateProvider<bool>((ref) => false);

@riverpod
class RidesNotifier extends _$RidesNotifier {
  @override
  Future<List<Ride>> build() async {
    return [];
  }

  Future<List<Ride>> searchRide(
    String startLocation,
    String endLocation,
    DateTime? from,
    DateTime? to,
  ) async {
    final rideService = ref.watch(rideServiceProvider);
    return rideService.searchRides(startLocation, endLocation, from, to);
  }

  Future<void> createRide(
    DateTime departureStartTime,
    DateTime departureEndTime,
    String? comments,
    int seats,
    String rideStart,
    String rideEnd,
  ) async {
    final rideService = ref.watch(rideServiceProvider);
    await rideService.createRide(
      departureStartTime,
      departureEndTime,
      comments,
      seats,
      rideStart,
      rideEnd,
    );
    ref.invalidate(upcomingRidesProvider);
  }

  Future<void> editRide(
    DateTime departureStartTime,
    DateTime departureEndTime,
    String? comments,
    int seats,
    String rideStart,
    String rideEnd,
    String rideId,
  ) async {
    final rideService = ref.watch(rideServiceProvider);
    await rideService.editRide(
      departureStartTime,
      departureEndTime,
      comments,
      seats,
      rideStart,
      rideEnd,
      rideId,
    );
    ref.invalidate(upcomingRidesProvider);
  }

  Future<void> sendRequest(int rideId) async {
    final rideService = ref.watch(rideServiceProvider);
    rideService.sendRequest(rideId);
  }

  Future<List<User>> getMembers(int rideId) async {
    final rideService = ref.watch(rideServiceProvider);
    return rideService.getMembers(rideId);
  }

  Future<void> manageRequest(
    int rideId,
    String requestUserEmail,
    String status,
  ) async {
    final rideService = ref.watch(rideServiceProvider);
    rideService.manageRequest(rideId, requestUserEmail, status);
  }

  Future<void> deleteRide(String rideId) async {
    final rideService = ref.watch(rideServiceProvider);
    await rideService.deleteRide(rideId);
    ref.invalidate(upcomingRidesProvider);
  }

  Future<void> deleteRequest(String rideId) async {
    final rideService = ref.watch(rideServiceProvider);
    rideService.deleteRequest(rideId);
  }

  Future<void> exitRide(String rideId) async {
    final rideService = ref.watch(rideServiceProvider);
    await rideService.exitRide(rideId);
    ref.invalidate(upcomingRidesProvider);
  }

  Future<void> refreshRides() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}

@riverpod
Future<List<Ride>> upcomingRides(Ref ref) async {
  final rideService = ref.watch(rideServiceProvider);
  return rideService.getUpcomingRides();
}

@riverpod
Future<List<Ride>> bookmarkedRides(Ref ref) async {
  final rideService = ref.watch(rideServiceProvider);
  return rideService.getBookmarkedRides();
}
