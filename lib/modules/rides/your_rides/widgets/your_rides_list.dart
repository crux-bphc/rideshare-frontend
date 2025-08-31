import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/models/ride.dart';
import 'package:rideshare/shared/widgets/ride_list_base.dart';

class YourRidesList extends ConsumerWidget {
  const YourRidesList({
    super.key,
    required this.rides,
  });

  final List<Ride> rides;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RideListBase(
      rides: rides,
      noRidesWidget: Center(
        child: Text(
          "No Upcoming Rides!",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
