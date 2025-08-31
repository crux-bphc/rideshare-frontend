import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/models/ride.dart';
import 'package:rideshare/modules/rides/available_rides/widgets/ride_card.dart';
import 'package:rideshare/shared/theme.dart';

class RideListBase extends ConsumerWidget {
  const RideListBase({
    super.key,
    required this.rides,
    required this.noRidesWidget,
  });

  final List<Ride> rides;
  final Widget noRidesWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (rides.isEmpty) {
      return noRidesWidget;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: rides.length,
            itemBuilder: (context, index) {
                final ride = rides[index];
                print("RIDE DETAILS");
                print("ride number");
                print(index);
                print("locations: ");
                print(ride.rideStartLocation);
                print("end location: ");
                print(ride.rideEndLocation);
                return RideCard(
                  ride: ride,
                );
            },
          ),
        ),
      ],
    );
  }
}