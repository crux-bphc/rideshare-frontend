import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rideshare/modules/rides/widgets/date_picker.dart';
import 'package:rideshare/modules/rides/widgets/time_picker.dart';
import 'package:rideshare/providers/rides/ridedata_provider.dart';

class SearchRidesScreen extends ConsumerWidget {
  const SearchRidesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rideDate = ref.watch(selectedDateProvider);
    final departureTime = ref.watch(departureTimeProvider);
    final arrivalTime = ref.watch(arrivalTimeProvider);
    final seats = ref.watch(seatProvider);
    final rideDateController = TextEditingController(
      text: rideDate != null ? "${rideDate.day}/${rideDate.month}/${rideDate.year}" : "",
    );
    final departureTimeController = TextEditingController(
      text: departureTime !=null ? "${departureTime.hour} : ${departureTime.minute}" : ""
    );
    final arrivalTimeController = TextEditingController(
      text: arrivalTime !=null ? "${arrivalTime.hour} : ${arrivalTime.minute}" : ""
    );
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
                ),
                SizedBox(height: 16.0),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Destination',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Ride Date',
                    hintText: 'Enter Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: rideDateController,
                  readOnly: true,
                  onTap: () async {
                    final picked = await showCustomDatePicker(context, initialDate: rideDate);
                    if (picked != null) {
                      ref.read(selectedDateProvider.notifier).setDate(picked);
                    }
                  },
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'From',
                          suffixIcon: Icon(Icons.access_time),
                        ),
                        readOnly: true,
                        controller: departureTimeController,
                        onTap: () async{
                          final picked = await showCustomTimePicker(context, initialTime: TimeOfDay.now());
                          if (picked != null) {
                            ref.read(departureTimeProvider.notifier).setTime(picked);
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'To',
                          suffixIcon: Icon(Icons.access_time),
                        ),
                        readOnly: true,
                        controller: arrivalTimeController,
                        onTap: () async{
                          final picked = await showCustomTimePicker(context, initialTime: TimeOfDay.now());
                          if (picked != null) {
                            ref.read(arrivalTimeProvider.notifier).setTime(picked);
                          }
                        },
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
                ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).go('/rides/available');
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(
                      double.infinity,
                      50,
                    ),
                  ),
                  child: const Text('Available rides'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
