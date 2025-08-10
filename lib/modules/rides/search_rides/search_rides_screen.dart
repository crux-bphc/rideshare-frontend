import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchRidesScreen extends ConsumerWidget {
  const SearchRidesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            padding: const EdgeInsets.all(16.0),
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
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      // TODO: Implement add stops functionality
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add stops'),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Ride Date',
                    hintText: 'Enter Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () {
                    // TODO: Implement date picker
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
                        onTap: () {
                          // TODO: Implement time picker
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
                        onTap: () {
                          // TODO: Implement time picker
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
                            // TODO: Implement decrement seats
                          },
                        ),
                        Text('4'),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: () {
                            // TODO: Implement increment seats
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
