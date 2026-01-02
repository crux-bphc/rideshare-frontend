import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rideshare/models/user.dart';
import 'package:rideshare/shared/theme.dart';

class MemberCard extends StatelessWidget {
  final User member;
  const MemberCard({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.card,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    member.phoneNumber,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.copy,
                color: AppColors.textSecondary,
                size: 20,
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: member.phoneNumber));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Copied Phone Number")),
                );
              },
              tooltip: 'Copy phone number',
            ),
          ],
        ),
      ),
    );
  }
}
