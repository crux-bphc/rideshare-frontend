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
    final ridesAsyncValue = GoRouterState.of(context).extra as List<Ride>;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: ridesAsyncValue.length + 1,
            itemBuilder: (context, index) {
              if (index < ridesAsyncValue.length) {
                final ride = ridesAsyncValue[index];
                return RideCard(ride: ride);
              } else {
                return Column(
                  children: [
                    SizedBox(height: 24),
                    Text(
                      "Did not find a ride you like? Create a ride instead",
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        GoRouter.of(context).go('/rides/create');
                      },
                      child: Text(
                        "Create Ride",
                        style: TextStyle(fontSize: 18),
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