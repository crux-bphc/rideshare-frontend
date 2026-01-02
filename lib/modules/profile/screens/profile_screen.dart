import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rideshare/modules/rides/available_rides/widgets/ride_card.dart';
import 'package:rideshare/modules/splash/splash_page.dart';
import 'package:rideshare/shared/providers/user_provider.dart';
import 'package:rideshare/shared/theme.dart';
import 'package:rideshare/providers/auth/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  // Future<User?> _getUserDetails(WidgetRef ref) async {
  //   final authState = ref.watch(authNotifierProvider);
  //   if (authState.value?.user?.email != null) {
  //     try {
  //       return await ref
  //           .read(userServiceProvider)
  //           .getUserDetails(authState.value!.user!.email!);
  //     } catch (e) {
  //       debugPrint('Error fetching user details: $e');
  //       return null;
  //     }
  //   }
  //   return null;
  // }

  // Future<List<Ride>> _getPastRides(WidgetRef ref) async {
  //   try {
  //     final rideService = ref.read(rideServiceProvider);
  //     final completedRides = await rideService.getCompletedRides();
  //     completedRides.sort(
  //       (a, b) => DateTime.parse(
  //         b.departureEndTime.toString(),
  //       ).compareTo(DateTime.parse(a.departureEndTime.toString())),
  //     );
  //     return completedRides.take(5).toList();
  //   } catch (e) {
  //     debugPrint('Error fetching completed rides: $e');
  //     return [];
  //   }
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetailsAsyncValue = ref.watch(profileUserDetailsProvider);
    final pastRidesAsyncValue = ref.watch(profilePastRidesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              ref.read(authNotifierProvider.notifier).logout();
              GoRouter.of(context).go('/');
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: userDetailsAsyncValue.when(
        data: (user) => pastRidesAsyncValue.when(
          data: (pastRides) => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          user?.name.toUpperCase() ?? 'USER',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          user?.email ?? 'No email available',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Colors.white70,
                              ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          user?.phoneNumber ?? 'No phone number',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Colors.white70,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Text(
                    'Past rides',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  if (pastRides.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'No past rides found',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: Colors.white70,
                              ),
                        ),
                      ),
                    )
                  else
                    ...pastRides.map((ride) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: RideCard(ride: ride),
                      );
                    }),
                ],
              ),
            ),
          ),
          loading: () => const SplashPage(),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
        loading: () => const SplashPage(),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
