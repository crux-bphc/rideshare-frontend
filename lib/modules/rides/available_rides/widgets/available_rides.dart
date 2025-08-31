import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rideshare/models/ride.dart';
import 'package:rideshare/modules/rides/available_rides/widgets/ride_card.dart';

class AvailableRidesList extends ConsumerWidget {
  const AvailableRidesList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rides = GoRouterState.of(context).extra as List<Ride>;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: rides.length + 1,
            itemBuilder: (context, index) {
              if (index < rides.length) {
                final ride = rides[index];
                return RideCard(ride: ride);
              } else {
                return Column(
                  children: [
                    SizedBox(height: 24),
                    Text(
                      "Did not find a ride you like? Create a ride instead",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
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
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
