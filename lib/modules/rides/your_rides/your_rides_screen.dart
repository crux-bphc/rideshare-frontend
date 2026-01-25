import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/modules/rides/your_rides/widgets/your_rides_list.dart';
import 'package:rideshare/modules/splash/splash_page.dart';
import 'package:rideshare/shared/providers/rides_provider.dart';
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
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Text('Your rides'),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
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
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white,
                labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Upcoming'),
                  Tab(text: 'Bookmarks'),
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              Consumer(
                builder: (context, ref, child) {
                  final upcomingRidesAsync = ref.watch(upcomingRidesProvider);
                  return upcomingRidesAsync.when(
                    data: (rides) {
                      if (rides.isEmpty) {
                        return Center(
                          child: Text(
                            'No upcoming rides.',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }
                      return YourRidesList(rides: rides);
                    },
                    loading: () => const SplashPage(),
                    error: (error, stack) => Center(
                      child: Text('No upcoming rides.'),
                    ),
                  );
                },
              ),
              Consumer(
                builder: (context, ref, child) {
                  final bookmarkedRidesAsync = ref.watch(bookmarkedRidesProvider);
                  return bookmarkedRidesAsync.when(
                    data: (rides) {
                      if (rides.isEmpty) {
                        return Center(
                          child: Text(
                            'No bookmarked rides.',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }
                      return YourRidesList(rides: rides);
                    },
                    loading: () => const SplashPage(),
                    error: (error, stack) => Center(
                      child: Text('No bookmarked rides.'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
