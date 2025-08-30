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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: rides.length + 1,
            itemBuilder: (context, index) {
              if (index < rides.length) {
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
                  actions: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.button,
                          foregroundColor: AppColors.textPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          minimumSize: const Size(0, 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'View Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 40,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.navbar,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.bookmark_outline,
                        color: AppColors.accent,
                        size: 20,
                      ),
                    ),
                  ],
                );
              } else {
                return noRidesWidget;
              }
            },
          ),
        ),
      ],
    );
  }
}