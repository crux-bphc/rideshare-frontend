import 'package:rideshare/providers/auth/logto_auth.dart';
import 'package:rideshare/models/ride.dart';
import 'package:rideshare/shared/services/ride_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rides_provider.g.dart';

final rideServiceProvider = Provider<RideService>((ref) {
  final dio = ref.watch(logtoAuthProvider).dioClient;
  return RideService(dio);
});

@riverpod
class RidesNotifier extends _$RidesNotifier {
  @override
  Future<List<Ride>> build() async {
    final rideService = ref.watch(rideServiceProvider);
    return rideService.searchRides(
      '', '', null, null
    ); // Empty search query to fetch all rides
  }

  Future<void> createRide(DateTime departureStartTime, DateTime departureEndTime, String? comments, int seats, String rideStart, String rideEnd) async {
    final rideService = ref.watch(rideServiceProvider);
    rideService.createRide(departureStartTime, departureEndTime, comments, seats, rideStart, rideEnd);
  }

  Future<void> refreshRides() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}
