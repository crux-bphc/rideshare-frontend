import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rideshare/models/ride.dart';
import 'package:rideshare/modules/rides/widgets/ride_card.dart';
import 'package:rideshare/shared/providers/rides_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AvailableRidesScreen extends ConsumerWidget {
  const AvailableRidesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ridesAsyncValue = GoRouterState.of(context).extra as List<Ride>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Rides'),
      ),
      body: ridesAsyncValue.isEmpty
          ? const Center(child: Text('No rides available.'))
          : ListView.builder(
              itemCount: ridesAsyncValue.length,
              itemBuilder: (context, index) {
                final ride = ridesAsyncValue[index];
                return RideCard(ride: ride, onJoinRide: () {});
              },
            ),
    );
  }
}
