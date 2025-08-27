import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/modules/rides/widgets/styled_input_container.dart';

import '../../../shared/util/datetime_utils.dart';
import '../search_rides/ridedata_provider.dart';

enum TimeFieldType { departure, arrival }

class TimePickerTextField extends ConsumerWidget {
  final String title;
  final TimeFieldType type;
  final VoidCallback onTap;
  final bool hasError;

  const TimePickerTextField({
    super.key,
    required this.title,
    required this.type,
    required this.onTap,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final time = ref.watch(
      type == TimeFieldType.departure
          ? departureTimeProvider
          : arrivalTimeProvider,
    );
    return StyledInputContainer(
      key: ValueKey(time),
      title: title,
      value: formatTime(time),
      icon: Icons.access_time_outlined,
      onTap: onTap,
      hasError: hasError,
    );
  }
}

class TimeWindowInput extends ConsumerWidget {
  final VoidCallback onDepartureTap;
  final VoidCallback onArrivalTap;
  final String? errorText;

  const TimeWindowInput({
    super.key,
    required this.onDepartureTap,
    required this.onArrivalTap,
    this.errorText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TimePickerTextField(
                title: 'From',
                type: TimeFieldType.departure,
                onTap: onDepartureTap,
                hasError: errorText != null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TimePickerTextField(
                title: 'To',
                type: TimeFieldType.arrival,
                onTap: onArrivalTap,
                hasError: errorText != null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
