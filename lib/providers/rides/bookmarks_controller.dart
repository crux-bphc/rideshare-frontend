import 'package:rideshare/shared/services/ride_service.dart';
import 'package:rideshare/shared/providers/rides_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class BookmarksController extends AsyncNotifier<Set<int>> {
  late final RideService _service;

  @override
  Future<Set<int>> build() async {
    _service = ref.read(rideServiceProvider);

    final rides = await _service.getBookmarkedRides();
    return rides.map((r) => r.id!).toSet();
  }

  Future<void> toggle(int rideId) async {
    if (state.isLoading) return;

    final current = state.value ?? {};
    final isBookmarked = current.contains(rideId);

    final updated = {...current};
    isBookmarked ? updated.remove(rideId) : updated.add(rideId);
    state = AsyncData(updated);

    try {
      await _service.toggleBookmark(
        rideId.toString(),
        isBookmarked,
      );
    } catch (e) {
      state = AsyncData(current);
      rethrow;
    }
  }
}

final bookmarksProvider = AsyncNotifierProvider<BookmarksController, Set<int>>(
  BookmarksController.new,
);
