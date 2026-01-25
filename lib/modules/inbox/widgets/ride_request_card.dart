import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rideshare/models/ride_request.dart';
import 'package:rideshare/modules/inbox/widgets/ride_card_actions.dart';
import 'package:rideshare/shared/theme.dart';
import 'package:rideshare/shared/util/datetime_utils.dart';

class RideCard extends ConsumerWidget {
  final RideRequest rideRequest;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final String? senderName;

  const RideCard({
    super.key,
    required this.rideRequest,
    required this.onAccept,
    required this.onDecline,
    this.senderName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 6, 8, 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: rideRequest.status == "accepted"
                ? AppColors.primary
                : rideRequest.status == "declined"
                ? AppColors.accent
                : const Color(0xFF303441),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      rideRequest.status == "pending"
                          ? "${senderName ?? rideRequest.requestSender} requested to join"
                          : "From: ${senderName ?? rideRequest.requestSender}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
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
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (rideRequest.departureStartTime != null) ...[
                    const SizedBox(width: 8),
                    const Text(
                      '|',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formatTimeRange(
                        rideRequest.departureStartTime,
                        rideRequest.departureEndTime,
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${rideRequest.rideStartLocation ?? "Unknown"} - ${rideRequest.rideEndLocation ?? "Unknown"}',
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.button,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              if (rideRequest.status == "pending")
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (rideRequest.maxMemberCount != null)
                      Text(
                        '${rideRequest.maxMemberCount} seats',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    SizedBox(
                      height: rideRequest.maxMemberCount != null ? 8 : 0,
                    ),
                    RideCardActions(
                      onAccept: onAccept,
                      onDecline: onDecline,
                    ),
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (rideRequest.maxMemberCount != null)
                      Text(
                        '${rideRequest.maxMemberCount} seats',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    Text(
                      "${rideRequest.status[0].toUpperCase()}${rideRequest.status.substring(1).toLowerCase()}",
                      style: TextStyle(
                        color: rideRequest.status == 'accepted'
                            ? AppColors.primary
                            : rideRequest.status == 'declined'
                            ? AppColors.textPrimary
                            : Colors.grey.shade500,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
