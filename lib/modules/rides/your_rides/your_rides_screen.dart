import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/models/ride.dart';
import 'package:rideshare/shared/providers/rides_provider.dart';
import 'package:rideshare/modules/rides/your_rides/widgets/your_rides_list.dart';
import 'package:rideshare/shared/theme.dart';

class YourRidesScreen extends ConsumerWidget {
  const YourRidesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your rides'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: AppColors.button,
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.white,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Upcoming'),
                  Tab(text: 'Bookmarks'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Consumer(builder: (context, ref, child) {
              final rideService = ref.read(rideServiceProvider);
              return FutureBuilder<List<Ride>>(
                future: rideService.getUpcomingRides(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No upcoming rides.'));
                  } else {
                    return YourRidesList(rides: snapshot.data!);
                  }
                },
              );
            }),
            Consumer(builder: (context, ref, child) {
              final rideService = ref.read(rideServiceProvider);
              return FutureBuilder<List<Ride>>(
                future: rideService.getBookmarkedRides(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No bookmarked rides.'));
                  } else {
                    return YourRidesList(rides: snapshot.data!);
                  }
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
