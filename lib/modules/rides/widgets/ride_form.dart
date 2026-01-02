import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/modules/rides/search_rides/ridedata_provider.dart';
import 'package:rideshare/modules/rides/search_rides/search_rides_screen.dart';
import 'package:rideshare/modules/rides/widgets/date_picker.dart';
import 'package:rideshare/modules/rides/widgets/location_path_input.dart';
import 'package:rideshare/modules/rides/widgets/seat_selector.dart';
import 'package:rideshare/modules/rides/widgets/time_input.dart';
import 'package:rideshare/modules/rides/widgets/time_picker.dart';

class RideForm extends ConsumerStatefulWidget {
  final TextEditingController startLocationController;
  final TextEditingController destinationLocationController;
  final String? startLocationError;
  final String? destinationLocationError;
  final String? dateError;
  final String? timeError;
  final String? seatsError;
  final bool showSeatsSelector;

  const RideForm({
    super.key,
    required this.startLocationController,
    required this.destinationLocationController,
    this.startLocationError,
    this.destinationLocationError,
    this.dateError,
    this.timeError,
    this.seatsError,
    this.showSeatsSelector = true,
  });

  @override
  ConsumerState<RideForm> createState() => _RideFormState();
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _RideFormState extends ConsumerState<RideForm> {
  Future<void> _selectDate() async {
    final currentDate = ref.read(selectedDateProvider);
    final picked = await showCustomDatePicker(
      context,
      initialDate: currentDate,
    );
    if (picked != null) {
      ref.read(selectedDateProvider.notifier).setDate(picked);
    }
  }

  Future<void> _selectDepartureTime() async {
    final picked = await showCustomTimePicker(
      context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      ref.read(departureTimeProvider.notifier).setTime(picked);
      final currentArrivalTime = ref.read(arrivalTimeProvider);

      if (currentArrivalTime != null && !picked.isBefore(currentArrivalTime)) {
        final departureMinutes = picked.hour * 60 + picked.minute;
        final newArrivalMinutes = departureMinutes + 30;
        final newArrivalHour = (newArrivalMinutes ~/ 60) % 24;
        final newArrivalMinute = newArrivalMinutes % 60;
        final newArrivalTime = TimeOfDay(
          hour: newArrivalHour,
          minute: newArrivalMinute,
        );
        ref.read(arrivalTimeProvider.notifier).setTime(newArrivalTime);
      }
    }
  }

  Future<void> _selectArrivalTime() async {
    final departureTime = ref.read(departureTimeProvider);
    final initialTime = departureTime != null
        ? TimeOfDay(
            hour:
                ((departureTime.hour * 60 + departureTime.minute + 30) ~/ 60) %
                24,
            minute: (departureTime.minute + 30) % 60,
          )
        : TimeOfDay.now();

    final picked = await showCustomTimePicker(
      context,
      initialTime: initialTime,
    );
    if (picked != null) {
      if (departureTime != null && !departureTime.isBefore(picked)) {
        final departureMinutes = departureTime.hour * 60 + departureTime.minute;
        final newArrivalMinutes = departureMinutes + 30;
        final newArrivalHour = (newArrivalMinutes ~/ 60) % 24;
        final newArrivalMinute = newArrivalMinutes % 60;
        final newArrivalTime = TimeOfDay(
          hour: newArrivalHour,
          minute: newArrivalMinute,
        );
        ref.read(arrivalTimeProvider.notifier).setTime(newArrivalTime);
      } else {
        ref.read(arrivalTimeProvider.notifier).setTime(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LocationPathInput(
          startController: widget.startLocationController,
          endController: widget.destinationLocationController,
          startError: widget.startLocationError,
          endError: widget.destinationLocationError,
        ),
        const SizedBox(height: 24),
        SectionHeader(title: 'Ride Date'),
        const SizedBox(height: 16),
        RideDateTextField(onTap: _selectDate, errorText: widget.dateError),
        const SizedBox(height: 24),
        SectionHeader(title: 'Departure window'),
        const SizedBox(height: 16),
        TimeWindowInput(
          onDepartureTap: _selectDepartureTime,
          onArrivalTap: _selectArrivalTime,
          errorText: widget.timeError,
        ),
        if (widget.timeError != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              widget.timeError!,
              style: TextStyle(
                color: theme.colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
        ],
        if (widget.showSeatsSelector) ...[
          const SizedBox(height: 24),
          SectionHeader(title: 'Seats Required'),
          const SizedBox(height: 16),
          const SeatSelection(),
          if (widget.seatsError != null) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                widget.seatsError!,
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ],
    );
  }
}
