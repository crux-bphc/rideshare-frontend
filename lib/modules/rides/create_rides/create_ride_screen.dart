import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/modules/rides/widgets/date_picker.dart';
import 'package:rideshare/modules/rides/widgets/time_picker.dart';
import 'package:rideshare/modules/rides/create_rides/ridedata_provider.dart';
import 'package:rideshare/shared/providers/rides_provider.dart';
import 'package:rideshare/shared/theme.dart';
import 'package:rideshare/shared/util/datetime_utils.dart';

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
            combineDateAndTime(rideDate!, departureTime!)!,
            combineDateAndTime(rideDate, arrivalTime!)!,
            null,
            seats,
            startLocationController.text,
            destinationLocationController.text,
          );
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
    print(departureTime != null && arrivalTime != null
        ? departureTime.isBefore(arrivalTime)
        : "null values");
    return rideDate != null &&
        departureTime != null &&
        arrivalTime != null &&
        startLocationController.text.trim().isNotEmpty &&
        destinationLocationController.text.trim().isNotEmpty &&
        departureTime.isBefore(arrivalTime);
  }

  @override
  Widget build(BuildContext context) {
    final rideDate = ref.watch(selectedDateProvider);
    final departureTime = ref.watch(departureTimeProvider);
    final arrivalTime = ref.watch(arrivalTimeProvider);
    final seats = ref.watch(seatProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Start Location',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  controller: startLocationController,
                ),
                SizedBox(height: 16.0),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Destination',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  controller: destinationLocationController,
                ),
                SizedBox(height: 16.0),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Ride Date',
                    hintText: 'Enter Date',
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                        ref.read(selectedDateProvider.notifier).setDate(null);
                        },
                      ),
                      Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                  controller: TextEditingController(text: formatDate(rideDate)),
                  readOnly: true,
                  onTap: _selectDate,
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'From',
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                            IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                              ref.read(departureTimeProvider.notifier).setTime(null);
                              },
                            ),
                            Icon(Icons.access_time),
                            ],
                          ),
                        ),
                        readOnly: true,
                        controller: TextEditingController(
                          text: formatTime(departureTime),
                        ),
                        onTap: _selectDepartureTime,
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'To',
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                            IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                              ref.read(arrivalTimeProvider.notifier).setTime(null);
                              },
                            ),
                            Icon(Icons.access_time),
                            ],
                          ),
                        ),
                        readOnly: true,
                        controller: TextEditingController(
                          text: formatTime(arrivalTime),
                        ),
                        onTap: _selectArrivalTime,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Seats Required'),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            ref
                                .read(seatProvider.notifier)
                                .decreaseSeats(seats);
                          },
                        ),
                        Text(seats.toString()),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: () {
                            ref
                                .read(seatProvider.notifier)
                                .increaseSeats(seats);
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 32.0),
                if (_canCreateRide)
                  ElevatedButton(
                    onPressed: _createRide,
                    child: const Text("Create Ride"),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
