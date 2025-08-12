import 'package:flutter/material.dart';
import 'package:rideshare/modules/inbox/models/ride.dart';
import 'package:rideshare/shared/theme.dart';

class RideCard extends StatelessWidget{
  final Ride ride;
  final double height;
  final double width;
  final double borderRadius;
  final EdgeInsets margin;
  final double borderThickness;
  final double fontSizeTitle;
  final double fontSizeSubtitle;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  

  const RideCard({
    super.key,
    required this.ride,
    required this.height,
    required this.width,
    required this.borderRadius,
    required this.borderThickness,
    required this.margin,
    required this.fontSizeSubtitle,
    required this.fontSizeTitle,
    required this.onAccept,
    required this.onDecline,

  });

    @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
                color: ride.status == "accepted"
                    ? AppColors.primary
                    : ride.status == "declined" ? AppColors.accent : Colors.grey.shade800,
                width: borderThickness,
              ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, 
          children: [
            // Top Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    ride.title,
                    style: TextStyle(
                        fontSize: fontSizeTitle,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              ride.date,
              style: TextStyle(
                fontSize: fontSizeSubtitle,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              ride.subtitle,
              style: TextStyle(
                fontSize: fontSizeTitle,
                color: AppColors.button,
                fontWeight: FontWeight.w900,
              ),
            ),

            SizedBox(height: 8,),

            Text(
              "Stops: ${ride.stop}",
              style: TextStyle(fontSize: fontSizeSubtitle, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            // Action Buttons or Status
            if (ride.status == "pending") ...[
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
            ] else if (ride.status == "accepted") ...[
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
            ] else if (ride.status == "declined") ...[
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