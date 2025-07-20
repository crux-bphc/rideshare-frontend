import 'package:flutter/material.dart';

class AppColors {
  static const Color surface = Color(0xFF111317);
  static const Color card = Color(0xFF21242D);
  static const Color primary = Color(0xFFA9AFFF);
  static const Color accent = Color(0xFFB8BDF8);
  static const Color button = Color(0xFF787FE4);
  static const Color buttonText = Colors.white;
  static const Color textPrimary = Colors.white;
  static const Color iconSelected = Color(0xFFA9AFFF);
  static const Color error = Color(0xFFFF5C5C);
  static const Color navbar = Color(0xFF1A1C23);
}

final ThemeData appTheme = ThemeData(
  fontFamily: 'Raleway',
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: AppColors.primary,
    secondary: AppColors.accent,
    surface: AppColors.surface,
    error: AppColors.error,
    onPrimary: AppColors.buttonText,
    onSecondary: AppColors.textPrimary,
    onSurface: AppColors.textPrimary,
    onError: AppColors.buttonText,
  ),
);
