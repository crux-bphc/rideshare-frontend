import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/providers/auth/auth_provider.dart';
import 'package:rideshare/shared/services/ride_service.dart';
import 'package:rideshare/shared/providers/rides_provider.dart';

class BookmarksController extends AsyncNotifier<Set<int>> {
  late final RideService _service;

  @override
  Future<Set<int>> build() async {
    _service = ref.read(rideServiceProvider);
    final authState = ref.watch(authNotifierProvider);
    if (!authReadyForUserApi(authState)) return {};

    final rides = await _service.getBookmarkedRides();
    return rides.map((r) => r.id).toSet();
  }

  Future<void> toggle(int rideId) async {
    if (state.isLoading) return;

    final current = state.value ?? {};
    final isBookmarked = current.contains(rideId);

    final updated = {...current};
    isBookmarked ? updated.remove(rideId) : updated.add(rideId);
    state = const AsyncLoading<Set<int>>();

    try {
      await _service.toggleBookmark(
        rideId.toString(),
        isBookmarked,
      );
      state = AsyncData(updated);
    } catch (e, _) {
      state = AsyncData(current);
    }
  }
}

final bookmarksProvider = AsyncNotifierProvider<BookmarksController, Set<int>>(
  BookmarksController.new,
);
