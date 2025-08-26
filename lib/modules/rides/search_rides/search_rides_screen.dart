import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rideshare/models/ride.dart';
import 'package:rideshare/modules/rides/widgets/date_picker.dart';
import 'package:rideshare/modules/rides/widgets/time_picker.dart';
import 'package:rideshare/providers/rides/ridedata_provider.dart';
import 'package:rideshare/shared/providers/rides_provider.dart';
import 'package:rideshare/shared/util/datetime_utils.dart';

class SearchRidesScreen extends ConsumerStatefulWidget {
  const SearchRidesScreen({super.key});

  @override
  ConsumerState<SearchRidesScreen> createState() => _SearchRidesScreenState();
}

class RideDateTextField extends ConsumerWidget {
  final VoidCallback onTap;
  const RideDateTextField({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rideDate = ref.watch(selectedDateProvider);
    return TextField(
      decoration: InputDecoration(
        labelText: 'Ride Date',
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
      readOnly: true,
      controller: TextEditingController(
        text: rideDate != null ? formatDate(rideDate) : '',
      ),
      onTap: onTap,
    );
  }
}

class DepartureTimeTextField extends ConsumerWidget {
  final VoidCallback onTap;
  const DepartureTimeTextField({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final departureTime = ref.watch(departureTimeProvider);
    return TextField(
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
      onTap: onTap,
    );
  }
}

class ArrivalTimeTextField extends ConsumerWidget {
  final VoidCallback onTap;
  const ArrivalTimeTextField({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arrivalTime = ref.watch(arrivalTimeProvider);
    return TextField(
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
      onTap: onTap,
    );
  }
}

class SeatSelection extends ConsumerWidget {
  const SeatSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seats = ref.watch(seatProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Seats Required'),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove_circle_outline),
              onPressed: () {
                ref.read(seatProvider.notifier).decreaseSeats(seats);
              },
            ),
            Text(seats.toString()),
            IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: () {
                ref.read(seatProvider.notifier).increaseSeats(seats);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _SearchRidesScreenState extends ConsumerState<SearchRidesScreen> {
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
    } catch (e) {
      print('Error creating ride: $e');
    }
  }

  Future<List<Ride>> _searchRide() async {
    final rideDate = ref.read(selectedDateProvider);
    final departureTime = ref.read(departureTimeProvider);
    final arrivalTime = ref.read(arrivalTimeProvider);

    try {
      return ref
          .read(rideServiceProvider)
          .searchRides(
            startLocationController.text,
            destinationLocationController.text,
            combineDateAndTime(rideDate, departureTime),
            combineDateAndTime(rideDate, arrivalTime)
          );
    } catch (e) {
      print('Error creating ride: $e');
    }
    return [];
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
    return Scaffold(
      body: Column(
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
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                  RideDateTextField(onTap: _selectDate),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: DepartureTimeTextField(onTap: _selectDepartureTime),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: ArrivalTimeTextField(onTap: _selectArrivalTime),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  SeatSelection(),
      
                  SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: () async{
                      final rides = await _searchRide();
                      GoRouter.of(context).go(
                        '/rides/available',
                        extra: rides,
                      );
                    },
                    child: const Text('Available rides'),
                  ),
                  SizedBox(
                    height: 12,
                  ),
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
      ),
    );
  }
}