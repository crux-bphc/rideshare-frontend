import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/modules/rides/widgets/date_picker.dart';
import 'package:rideshare/modules/rides/widgets/time_picker.dart';
import 'package:rideshare/modules/rides/search_rides/ridedata_provider.dart';
import 'package:rideshare/shared/providers/rides_provider.dart';
import 'package:rideshare/shared/theme.dart';
import 'package:rideshare/shared/util/datetime_utils.dart';

import '../search_rides/search_rides_screen.dart';
import '../widgets/location_path_input.dart';
import '../widgets/seat_selector.dart';
import '../widgets/time_input.dart';

class CreateRideScreen extends ConsumerStatefulWidget {
  const CreateRideScreen({super.key});

  @override
  ConsumerState<CreateRideScreen> createState() => _CreateRideScreenState();
}

class _CreateRideScreenState extends ConsumerState<CreateRideScreen> {
  late final TextEditingController startLocationController;
  late final TextEditingController destinationLocationController;

  @override
  void initState() {
    super.initState();
    startLocationController = TextEditingController();
    destinationLocationController = TextEditingController();
  }

  @override
  void dispose() {
    startLocationController.dispose();
    destinationLocationController.dispose();
    super.dispose();
  }

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
    }
  }

  Future<void> _selectArrivalTime() async {
    final picked = await showCustomTimePicker(
      context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      ref.read(arrivalTimeProvider.notifier).setTime(picked);
    }
  }

  Future<void> _createRide() async {
    final rideDate = ref.read(selectedDateProvider);
    final departureTime = ref.read(departureTimeProvider);
    final arrivalTime = ref.read(arrivalTimeProvider);
    final seats = ref.read(seatProvider);

    try {
      await ref
          .read(rideServiceProvider)
          .createRide(
            combineDateAndTime(rideDate, departureTime!)!,
            combineDateAndTime(rideDate, arrivalTime!)!,
            null,
            seats,
            startLocationController.text,
            destinationLocationController.text,
          );
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Ride Created!',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            content: Text(
              'Your ride has been successfully created.',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _resetForm();
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error creating ride: $e');
    }
  }

  void _resetForm() {
    startLocationController.clear();
    destinationLocationController.clear();
    ref.read(selectedDateProvider.notifier).setDate(null);
    ref.read(departureTimeProvider.notifier).setTime(null);
    ref.read(arrivalTimeProvider.notifier).setTime(null);
    ref.read(seatProvider.notifier).resetSeats();
  }

  bool get _canCreateRide {
    final rideDate = ref.watch(selectedDateProvider);
    final departureTime = ref.watch(departureTimeProvider);
    final arrivalTime = ref.watch(arrivalTimeProvider);
    print(
      departureTime != null && arrivalTime != null
          ? departureTime.isBefore(arrivalTime)
          : "null values",
    );
    return rideDate != null &&
        departureTime != null &&
        arrivalTime != null &&
        startLocationController.text.trim().isNotEmpty &&
        destinationLocationController.text.trim().isNotEmpty &&
        departureTime.isBefore(arrivalTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Create Ride'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              LocationPathInput(
                startController: startLocationController,
                endController: destinationLocationController,
                startError: null,
                endError: null,
              ),

              const SizedBox(height: 24),
              RideDateTextField(onTap: _selectDate, errorText: null),

              const SizedBox(height: 24),

              TimeWindowInput(
                onDepartureTap: _selectDepartureTime,
                onArrivalTap: _selectArrivalTime,
                errorText: null,
              ),

              const SizedBox(height: 24),
              const SeatSelection(),

              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canCreateRide ? _createRide : null,
                  style: Theme.of(context).elevatedButtonTheme.style,
                  child: const Text(
                    'Create Ride',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
