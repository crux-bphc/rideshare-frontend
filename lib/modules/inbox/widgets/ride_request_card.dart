import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rideshare/models/ride_request.dart';
import 'package:rideshare/shared/providers/user_provider.dart';
import 'package:rideshare/shared/theme.dart';
import 'package:rideshare/shared/util/datetime_utils.dart';

class RideCard extends StatelessWidget{
  final RideRequest rideRequest;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  

  const RideCard({
    super.key,
    required this.rideRequest,
    required this.onAccept,
    required this.onDecline,

  });

    @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: rideRequest.status == "accepted"
              ? AppColors.primary
              : rideRequest.status == "declined" ? AppColors.accent : Colors.grey.shade800,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: FutureBuilder(
                    future: UserNotifier().getUser(rideRequest.requestSender),
                    builder: (context, snapshot) {
                      String displayName = rideRequest.requestSender;
                      if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                        displayName = snapshot.data?.name ?? rideRequest.requestSender;
                      }
                      return Text(
                        rideRequest.status == "pending"
                          ? "$displayName requested to join"
                          : "From: $displayName",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Text(
                  rideRequest.departureStartTime != null
                    ? "${DateFormat('d').format(rideRequest.departureStartTime!)}${getDaySuffix(rideRequest.departureStartTime!.day)} ${DateFormat('MMM').format(rideRequest.departureStartTime!)}"
                    : '',
                  style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
                ),
                if (rideRequest.departureStartTime != null) ...[
                  const SizedBox(width: 8),
                  Text('|', style: TextStyle(fontSize: 14, color: AppColors.textPrimary)),
                  const SizedBox(width: 8),
                  Text(
                    formatTimeRange(rideRequest.departureStartTime, rideRequest.departureEndTime),
                    style: TextStyle(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${rideRequest.rideStartLocation ?? "Unknown"} - ${rideRequest.rideEndLocation ?? "Unknown"}',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.button,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            if (rideRequest.maxMemberCount != null)
              Text(
                '${rideRequest.maxMemberCount} seats',
                style: TextStyle(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
              ),
            const SizedBox(height: 16),
            if (rideRequest.status == "pending") ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.button,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Accept",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onDecline,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.altButton,
                        foregroundColor: AppColors.textPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Decline",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100),
                      ),
                    ),
                  ),
                ],
              )
            ] else if (rideRequest.status == "accepted") ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 120,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.button,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Accepted",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              )
            ] else if (rideRequest.status == "declined") ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 120,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.altButton,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Declined",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }

}