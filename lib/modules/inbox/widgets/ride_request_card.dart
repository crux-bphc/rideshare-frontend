import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rideshare/models/ride_request.dart';
import 'package:rideshare/modules/inbox/widgets/ride_card_actions.dart';
import 'package:rideshare/shared/providers/user_provider.dart';
import 'package:rideshare/shared/theme.dart';
import 'package:rideshare/shared/util/datetime_utils.dart';

class RideCard extends ConsumerWidget{
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
  Widget build(BuildContext context, WidgetRef ref) {
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
                    future: ref.read(userNotifierProvider.notifier).getUser(rideRequest.requestSender),
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
            RideCardActions(
              status: rideRequest.status,
              onAccept: onAccept,
              onDecline: onDecline,
            )
          ],
        ),
      ),
    );
  }

}