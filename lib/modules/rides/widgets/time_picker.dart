import 'package:flutter/material.dart';
import 'package:rideshare/shared/theme.dart';

Future<TimeOfDay?> showCustomTimePicker(
  BuildContext context, {
  TimeOfDay? initialTime,
}) {
  return showTimePicker(
    context: context,
    initialTime: initialTime ?? TimeOfDay.now(),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.surface,
            onPrimary: AppColors.textPrimary,
            surface: AppColors.surface,
            onSurface: AppColors.textSecondary,
            secondary: AppColors.textPrimary,
          ),

          // Theme specifically for TimePicker
          timePickerTheme: TimePickerThemeData(
            backgroundColor: AppColors.surface,
            hourMinuteTextColor: AppColors.primary,
            dialHandColor: AppColors.primary,
            dialBackgroundColor: AppColors.surface,
            entryModeIconColor: AppColors.primary,

            dayPeriodTextColor: AppColors.textPrimary,
            dayPeriodColor: AppColors.primary,
            dayPeriodShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),

          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          dialogTheme: DialogThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
        child: child!,
      );
    },
  );
}
