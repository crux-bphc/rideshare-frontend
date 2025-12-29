import 'package:flutter/material.dart';
import 'package:rideshare/shared/theme.dart';

class RideCardActions extends StatelessWidget {
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  const RideCardActions({
    super.key,
    this.onAccept,
    this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return PendingStatus(
      onAccept: onAccept,
      onDecline: onDecline,
    );
  }
}

class PendingStatus extends StatelessWidget {
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  const PendingStatus({
    super.key,
    this.onAccept,
    this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
              side: BorderSide(color: Color(0xFF303441), width: 1),
            ),
            child: const Text(
              "Decline",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100),
            ),
          ),
        ),
      ],
    );
  }
}
