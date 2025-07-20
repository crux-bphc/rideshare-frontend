import 'package:flutter/material.dart';

const Color _primaryColor = Color(0xFF777FE4);
const Color _backgroundColor = Color(0xFF101317);
const Color _cardColor = Color(0xFF1E2128);

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: _primaryColor,
    onPrimary: Colors.white,
    surface: _backgroundColor,
    onSurface: Colors.white,
    error: Colors.red,
    onError: Colors.white,
  ),
  useMaterial3: true,
  scaffoldBackgroundColor: _backgroundColor,
  cardColor: _cardColor,
  appBarTheme: AppBarTheme(
    centerTitle: false,
    elevation: 0,
    backgroundColor: _backgroundColor,
    foregroundColor: Colors.white,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    selectedItemColor: _primaryColor,
    unselectedItemColor: _primaryColor,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: _primaryColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: _cardColor,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    hintStyle: TextStyle(color: Colors.white.withAlpha((0.6 * 255).round())),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
  ),
);