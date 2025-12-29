import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/models/ride_request.dart';
import 'package:rideshare/shared/providers/rides_provider.dart';
import 'package:rideshare/shared/providers/user_provider.dart';


class RideRequestsAsyncNotifier extends AsyncNotifier<List<RideRequest>> {
  @override
  Future<List<RideRequest>> build() async {
    final userNotifier = ref.read(userNotifierProvider.notifier);
    return await userNotifier.getRequestsReceived();
  }

  Future<void> refreshRequests() async {
    state = const AsyncLoading();
    try {
      final userNotifier = ref.read(userNotifierProvider.notifier);
      final requests = await userNotifier.getRequestsReceived();
      state = AsyncData(requests);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> updateRequestStatus(int requestId, String newStatus) async {
    state.whenData((requests) {
      final updatedRequests = requests.map((request) {
        if (request.id == requestId) {
          request = request.copyWith(status: newStatus);
        }
        return request;
      }).toList();
      
      state = AsyncData(updatedRequests);
    });
  }

  Future<void> handleRequest(int requestId, String requestSender, String status) async {
    try {
      await ref.read(ridesNotifierProvider.notifier).manageRequest(
        requestId,
        requestSender,
        status,
      );
      await updateRequestStatus(requestId, status);
    } catch (error) {
      await refreshRequests();
      rethrow;
    }
  }
}

final rideRequestsAsyncProvider = AsyncNotifierProvider<RideRequestsAsyncNotifier, List<RideRequest>>(() {
  return RideRequestsAsyncNotifier();
});

class SentRequestsAsyncNotifier extends AsyncNotifier<List<RideRequest>> {
  @override
  Future<List<RideRequest>> build() async {
    final userNotifier = ref.read(userNotifierProvider.notifier);
    return await userNotifier.getSentRequests();
  }

  Future<void> refreshRequests() async {
    state = const AsyncLoading();
    try {
      final userNotifier = ref.read(userNotifierProvider.notifier);
      final requests = await userNotifier.getSentRequests();
      state = AsyncData(requests);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> deleteRequest(int requestId) async {
    try {
      await ref.read(ridesNotifierProvider.notifier).deleteRequest(requestId.toString());
      await refreshRequests();
    } catch (error) {
      rethrow;
    }
  }
}

final sentRequestsAsyncProvider = AsyncNotifierProvider<SentRequestsAsyncNotifier, List<RideRequest>>(() {
  return SentRequestsAsyncNotifier();
});

//using async provider for the first time was actually fun