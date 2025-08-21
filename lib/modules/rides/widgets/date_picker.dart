import 'package:flutter/material.dart';
import 'package:rideshare/shared/theme.dart';

Future<DateTime?> showCustomDatePicker(BuildContext context,
    {DateTime? initialDate}) {
  return showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.dark(
            primary: AppColors.primary,
            onPrimary: AppColors.textPrimary,
            surface: AppColors.surface,
            onSurface: AppColors.textPrimary,
          ),
          datePickerTheme: DatePickerThemeData(
            backgroundColor: AppColors.surface,
            headerBackgroundColor: AppColors.surface,
            headerForegroundColor: AppColors.textPrimary,
            weekdayStyle: TextStyle(color: AppColors.textSecondary),
            dayStyle: TextStyle(color: AppColors.textPrimary),
            yearStyle: TextStyle(color: AppColors.textPrimary),
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
            backgroundColor: AppColors.surface,
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