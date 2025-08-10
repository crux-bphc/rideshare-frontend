import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rideshare/shared/providers/rides_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AvailableRidesScreen extends ConsumerWidget {
  const AvailableRidesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ridesAsyncValue = ref.watch(ridesNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Rides'),
      ),
      body: ridesAsyncValue.when(
        data: (rides) {
          if (rides.isEmpty) {
            return const Center(child: Text('No rides available.'));
          }
          return ListView.builder(
            itemCount: rides.length,
            itemBuilder: (context, index) {
              final ride = rides[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Created By: ${ride.createdBy}'),
                      Text('From: ${ride.rideStartLocation ?? 'N/A'}'),
                      Text('To: ${ride.rideEndLocation ?? 'N/A'}'),
                      Text(
                        'Departure: ${ride.departureStartTime?.toLocal().toString().split(' ')[0] ?? 'N/A'}',
                      ),
                      Text(
                        'Arrival: ${ride.departureEndTime?.toLocal().toString().split(' ')[0] ?? 'N/A'}',
                      ),
                      Text('Max Members: ${ride.maxMemberCount ?? 'N/A'}'),
                      Text('Comments: ${ride.comments ?? 'N/A'}'),
                      ElevatedButton(
                        onPressed: () {
                          context.go('/rides/details', extra: ride);
                        },
                        child: const Text('View Details'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
