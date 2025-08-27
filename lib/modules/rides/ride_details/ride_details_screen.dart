import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/models/ride.dart';
import 'package:rideshare/modules/rides/ride_details/widgets/route_icon.dart';
import 'package:rideshare/shared/providers/rides_provider.dart';
import 'package:rideshare/shared/theme.dart';
import 'package:intl/intl.dart';

class RideDetailsScreen extends ConsumerWidget {
  final Ride ride;
  const RideDetailsScreen({super.key, required this.ride});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor:AppColors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ride Details',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor:AppColors.iconSelected,
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Alice Jayson',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(
                        '+91 9999999999',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  (ride.departureEndTime!.day == ride.departureStartTime!.day) ?
                   '${DateFormat("d MMM").format(ride.departureStartTime!)} ${DateFormat("HH:mm").format(ride.departureStartTime!)} - ${DateFormat("HH:mm").format(ride.departureEndTime!)}' 
                   : '${DateFormat("d MMM HH:mm").format(ride.departureStartTime!)} - ${DateFormat("d MMM HH:mm").format(ride.departureEndTime!)}',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    "${ride.maxMemberCount.toString()} seats",
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
              Column(
                children: [
                  RouteIcon(icon: Icons.location_on, iconColor: AppColors.button, label: ride.rideStartLocation ?? 'N/A'),
                  SizedBox(height: 24),
                  RouteIcon(icon: Icons.location_on, iconColor: AppColors.button, label: ride.rideEndLocation ?? 'N/A'),
                ],
              ),
            const SizedBox(height:30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(rideServiceProvider).sendRequest(ride.id);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Send request to join'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
