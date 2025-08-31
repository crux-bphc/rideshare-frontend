import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rideshare/models/ride.dart';
import 'package:rideshare/shared/widgets/ride_list_base.dart';

class AvailableRidesList extends ConsumerWidget {
  const AvailableRidesList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rides = GoRouterState.of(context).extra as List<Ride>;

    return RideListBase(
      rides: rides,
      noRidesWidget: Column(
        children: [
          const SizedBox(height: 24),
          Text(
            "Did not find a ride you like? Create a ride instead",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              GoRouter.of(context).go('/rides/create');
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Create Ride',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
