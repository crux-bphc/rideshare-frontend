import 'package:flutter/material.dart';
import 'package:rideshare/shared/theme.dart';

Widget RouteIcon({
  required IconData icon,
  required Color iconColor,
  required String label,
}) {
  return Row(
    children: [
      Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16,
          color: iconColor,
        ),
      ),
      const SizedBox(width: 16),
      Text(
        label[0].toUpperCase() + label.substring(1),
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
        ),
      ),
    ],
  );
}
