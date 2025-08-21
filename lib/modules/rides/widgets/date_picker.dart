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
          
          colorScheme: ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: AppColors.textPrimary,
            onSurface: AppColors.surface,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
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
