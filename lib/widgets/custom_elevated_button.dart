import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Widget? icon;
  final Color? bgColor;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon ?? const SizedBox.shrink(),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor ?? const Color(0xFF777FE4),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}