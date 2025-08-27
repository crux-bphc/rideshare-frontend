import 'package:flutter/material.dart';
import 'package:rideshare/models/ride.dart';

class RideDetailsScreen extends StatelessWidget {
  final Ride ride;
  const RideDetailsScreen({super.key, required this.ride});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ride details',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16.0),
            Text('Created By: ${ride.createdBy}'),
            SizedBox(height: 8.0),
            Text('Max Members: ${ride.maxMemberCount ?? 'N/A'}'),
            SizedBox(height: 16.0),
            // Ride route details
            Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(width: 8.0),
                Text('Start: ${ride.rideStartLocation ?? 'N/A'}'),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(width: 8.0),
                Text('End: ${ride.rideEndLocation ?? 'N/A'}'),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              'Departure Time: ${ride.departureStartTime?.toLocal().toString() ?? 'N/A'}',
            ),
            SizedBox(height: 8.0),
            Text(
              'Arrival Time: ${ride.departureEndTime?.toLocal().toString() ?? 'N/A'}',
            ),
            SizedBox(height: 16.0),
            if (ride.comments != null && ride.comments!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Comments',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  TextField(
                    maxLines: 3,
                    readOnly: true,
                    controller: TextEditingController(text: ride.comments),
                    decoration: InputDecoration(
                      hintText: 'No comments',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
            Text(
              'Others part of the ride',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8.0),
            // TODO: Display other passengers if available
            SizedBox(height: 32.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement send request to join functionality
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Send request to join'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
