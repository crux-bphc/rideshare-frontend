import 'package:flutter/material.dart';
import '../../../shared/theme.dart';

class LocationPathInput extends StatelessWidget {
  final TextEditingController startController;
  final TextEditingController endController;
  final String? startError;
  final String? endError;

  const LocationPathInput({
    super.key,
    required this.startController,
    required this.endController,
    this.startError,
    this.endError,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _LocationInputRow(
                icon: Icons.circle_outlined,
                hint: 'Start Location',
                controller: startController,
                errorText: startError,
              ),
              const SizedBox(
                height: 16,
              ),
              _LocationInputRow(
                icon: Icons.location_on,
                hint: 'Destination',
                controller: endController,
                errorText: endError,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LocationInputRow extends StatelessWidget {
  final IconData icon;
  final String hint;
  final TextEditingController controller;
  final String? errorText;

  const _LocationInputRow({
    required this.icon,
    required this.hint,
    required this.controller,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.primary.withAlpha((0.1 * 255).round()),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.white.withAlpha((0.7 * 255).round()),
              ),
              errorText: errorText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: errorText != null
                      ? Theme.of(context).colorScheme.error
                      : Colors.transparent,
                ),
              ),
              filled: true,
              fillColor: AppColors.card,
            ),
          ),
        ),
      ],
    );
  }
}
