import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rideshare/models/ride.dart';
import 'package:rideshare/modules/rides/available_rides/widgets/available_rides.dart';
import 'package:rideshare/modules/rides/available_rides/widgets/no_ride.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AvailableRidesScreen extends ConsumerWidget {
  const AvailableRidesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rides = GoRouterState.of(context).extra as List<Ride>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Rides'),
      ),
      body: rides.isEmpty ? NoRideScreen() : AvailableRidesList(),
    );
  }
}
