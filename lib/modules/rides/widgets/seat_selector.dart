import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/shared/theme.dart';
import 'package:rideshare/modules/rides/search_rides/ridedata_provider.dart';

class SeatSelection extends ConsumerWidget {
  const SeatSelection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seats = ref.watch(seatProvider);
    final theme = Theme.of(context);

    final ButtonStyle? baseStyle = theme.elevatedButtonTheme.style;

    final ButtonStyle compactButtonStyle = baseStyle!.copyWith(
      padding: WidgetStateProperty.all(EdgeInsets.zero),
      minimumSize: WidgetStateProperty.all(const Size(44, 44)),
      maximumSize: WidgetStateProperty.all(const Size(44, 44)),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              if (seats > 2) {
                ref.read(seatProvider.notifier).decreaseSeats(seats);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: AppColors.error,
                    content: Text('You must select at least 2 seats.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            style: compactButtonStyle,
            child: const Icon(Icons.remove),
          ),
          SizedBox(
            width: 50,
            child: Center(
              child: Text(
                seats.toString(),
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () =>
                ref.read(seatProvider.notifier).increaseSeats(seats),
            style: compactButtonStyle,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
