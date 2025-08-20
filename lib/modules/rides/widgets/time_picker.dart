import 'package:flutter/material.dart';
import 'package:rideshare/shared/theme.dart';

Future<TimeOfDay?> showCustomTimePicker(BuildContext context, {TimeOfDay? initialTime}) {
  return showTimePicker(
    context: context,
    initialTime: initialTime ?? TimeOfDay.now(),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.surface,        // Dial hand & header background
            onPrimary: AppColors.textPrimary,  // Header text & dial text when selected
            surface: AppColors.surface,        // Dialog background
            onSurface: AppColors.textSecondary,// Unselected text (hours, minutes, AM/PM)
            secondary: AppColors.textPrimary,      // Used by AM/PM selected
          ),

          // Theme specifically for TimePicker
          timePickerTheme: TimePickerThemeData(
            backgroundColor: AppColors.surface,
            hourMinuteTextColor: AppColors.primary,
            dialHandColor: AppColors.primary,
            dialBackgroundColor: AppColors.surface,
            entryModeIconColor: AppColors.primary,

            dayPeriodTextColor: AppColors.textPrimary, // AM/PM text color
            dayPeriodColor: AppColors.primary,
            dayPeriodShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),

          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,   // OK / CANCEL button text
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
