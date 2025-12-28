import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rideshare/models/ride.dart';
import 'package:rideshare/models/ride_request.dart';
import 'package:rideshare/shared/providers/user_provider.dart';
import 'package:rideshare/shared/theme.dart';
import 'package:rideshare/shared/util/datetime_utils.dart';

class SentRequestCard extends ConsumerWidget {
  final RideRequest rideRequest;
  final VoidCallback? onDelete;

  const SentRequestCard({
    super.key,
    required this.rideRequest,
    this.onDelete,
  });
  Ride _convertToRide(RideRequest request) {
    return Ride(
      id: request.id,
      createdBy: request.createdBy,
      comments: request.comments,
      departureStartTime: request.departureStartTime,
      departureEndTime: request.departureEndTime,
      maxMemberCount: request.maxMemberCount,
      rideStartLocation: request.rideStartLocation,
      rideEndLocation: request.rideEndLocation,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        final ride = _convertToRide(rideRequest);
        context.push("/rides/details", extra: ride);
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: rideRequest.status == "accepted"
                ? AppColors.primary
                : rideRequest.status == "declined" 
                    ? AppColors.accent 
                    : Colors.grey.shade800,
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
                    child: rideRequest.createdBy.isEmpty
                        ? Text(
                            "To: Unknown",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          )
                        : FutureBuilder(
                            future: ref.read(userNotifierProvider.notifier).getUser(rideRequest.createdBy),
                            builder: (context, snapshot) {
                              String displayName = rideRequest.createdBy;
                              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                                displayName = snapshot.data?.name ?? rideRequest.createdBy;
                              }
                              return Text(
                                "To: $displayName",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              );
                            },
                          ),
                  ),
                  if (rideRequest.status == "pending" && onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete, color: AppColors.error),
                      onPressed: onDelete,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 120,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: (rideRequest.status == 'accepted') 
                            ? AppColors.button 
                            : (rideRequest.status == 'declined')
                                ? AppColors.altButton
                                : Colors.grey.shade700,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        rideRequest.status.isEmpty
                            ? "Pending"
                            : "${rideRequest.status[0].toUpperCase()}${rideRequest.status.substring(1).toLowerCase()}",
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
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

