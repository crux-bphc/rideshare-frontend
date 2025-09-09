import 'package:flutter/material.dart';
import 'package:rideshare/shared/theme.dart';

class RideCardActions extends StatelessWidget {
  final String status;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  const RideCardActions({
    super.key,
    required this.status,
    this.onAccept,
    this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    if (status == "pending"){
      return PendingStatus(onAccept: onAccept, onDecline: onDecline,);
    }
    else{
      return NotPending(status: status);
    }
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

class NotPending extends StatelessWidget {
  final String status;

  const NotPending({
    super.key,
    required this.status
  });

  @override
  Widget build(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 120,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: (status=='accepted') ? AppColors.button : AppColors.altButton,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "${status[0].toUpperCase()}${status.substring(1).toLowerCase()}",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}