import 'package:flutter/material.dart';
import 'package:rideshare/models/ride.dart';
import 'package:intl/intl.dart';
import 'package:rideshare/shared/theme.dart';

class RideCard extends StatelessWidget {
  final Ride ride;

  const RideCard({
    super.key,
    required this.ride,
    this.actions = const [],
  });

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 6, 8, 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${DateFormat("d/MM/yy HH:mm").format(ride.departureStartTime!)} - ${DateFormat("d/MM/yy HH:mm").format(ride.departureEndTime!)}',
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${ride.maxMemberCount} seats',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Text(
              "${ride.rideStartLocation} - ${ride.rideEndLocation}",
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            Row(
              children: actions,
            ),
          ],
        ),
      ),
    );
  }
}