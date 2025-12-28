import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rideshare/models/ride.dart';
import 'package:rideshare/models/user.dart';
import 'package:rideshare/modules/inbox/provider/ride_requests_provider.dart';
import 'package:rideshare/modules/rides/ride_details/widgets/member_card.dart';
import 'package:rideshare/modules/rides/ride_details/widgets/route_icon.dart';
import 'package:rideshare/modules/splash/splash_page.dart';
import 'package:rideshare/shared/providers/navigation_provider.dart';
import 'package:rideshare/shared/providers/rides_provider.dart';
import 'package:rideshare/shared/providers/user_provider.dart';
import 'package:rideshare/shared/theme.dart';
import 'package:intl/intl.dart';

class RideDetailsScreen extends ConsumerWidget {
  final Ride ride;
  const RideDetailsScreen({super.key, required this.ride});

  Future<String?> _getEmail(WidgetRef ref) async {
    return await ref.read(userServiceProvider).getUserEmail();
  }
  Future<User?> getDetails(WidgetRef ref, String email) async {
    return await ref.read(userServiceProvider).getUserDetails(email);
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<User?>(
      future: getDetails(ref, ride.createdBy),
      builder: (context, creatorSnapshot) {
        if (creatorSnapshot.connectionState == ConnectionState.waiting) {
          return const SplashPage();
        }
        if (creatorSnapshot.hasError || !creatorSnapshot.hasData || creatorSnapshot.data == null) {
          return Scaffold(
            backgroundColor: AppColors.surface,
            body: Center(child: Text('Error loading creator details', style: TextStyle(color: AppColors.textPrimary))),
          );
        }
        final creator = creatorSnapshot.data!;
        return FutureBuilder<List<User>>(
          future: ref.read(ridesNotifierProvider.notifier).getMembers(ride.id),
          builder: (context, membersSnapshot) {
            if (membersSnapshot.connectionState == ConnectionState.waiting) {
              return const SplashPage();
            }
            if (membersSnapshot.hasError) {
              return Scaffold(
                backgroundColor: AppColors.surface,
                body: Center(child: Text('Error loading members', style: TextStyle(color: AppColors.textPrimary))),
              );
            }
            final members = membersSnapshot.data ?? [];
            return Scaffold(
              backgroundColor:AppColors.surface,
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                      // Restore inbox tab if we're going back to inbox
                      Future.delayed(const Duration(milliseconds: 50), () {
                        if (context.mounted) {
                          final location = GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();
                          if (location.contains('/inbox')) {
                            ref.read(navigationNotifierProvider.notifier).setTab(NavigationTab.inbox);
                          }
                        }
                      });
                    } else {
                      // Fallback: go to inbox
                      ref.read(navigationNotifierProvider.notifier).setTab(NavigationTab.inbox);
                      context.go('/inbox');
                    }
                  },
                ),
                title: const Text('Ride Details'),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor:AppColors.iconSelected,
                          child: Icon(Icons.person, color: AppColors.accent, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                creator.name,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                creator.phoneNumber,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          (ride.departureEndTime!.day == ride.departureStartTime!.day) ?
                           '${DateFormat("d MMM").format(ride.departureStartTime!)} ${DateFormat("HH:mm").format(ride.departureStartTime!)} - ${DateFormat("HH:mm").format(ride.departureEndTime!)}' 
                           : '${DateFormat("d MMM HH:mm").format(ride.departureStartTime!)} - ${DateFormat("d MMM HH:mm").format(ride.departureEndTime!)}',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            "${ride.maxMemberCount.toString()} seats",
                            style: TextStyle(
                              color: AppColors.accent,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Column(
                      children: [
                        RouteIcon(icon: Icons.location_on, iconColor: AppColors.button, label: ride.rideStartLocation ?? 'N/A'),
                        const SizedBox(height: 24),
                        RouteIcon(icon: Icons.location_on, iconColor: AppColors.button, label: ride.rideEndLocation ?? 'N/A'),
                      ],
                    ),
                    const SizedBox(height: 30),
                    if (members.isNotEmpty) ...[
                      Text('Members:', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      FutureBuilder<String?>(
                        future: _getEmail(ref),
                        builder: (context, emailSnapshot) {
                          final currentUserEmail = emailSnapshot.data;
                          final isCurrentUserCreator = currentUserEmail != null && ride.createdBy == currentUserEmail;
                          
                          return Column(
                            children: members.map((m) {
                              final isCurrentUser = currentUserEmail != null && m.email == currentUserEmail;
                              final showExitButton = isCurrentUser && !isCurrentUserCreator;
                              
                              return Card(
                                color: AppColors.card,
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              m.name,
                                              style: const TextStyle(
                                                color: AppColors.textPrimary,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              m.phoneNumber,
                                              style: const TextStyle(
                                                color: AppColors.textSecondary,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (showExitButton)
                                        TextButton.icon(
                                          onPressed: () async {
                                            try {
                                              await ref.read(ridesNotifierProvider.notifier).exitRide(ride.id.toString());
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('Successfully exited the ride'),
                                                    backgroundColor: AppColors.success,
                                                  ),
                                                );
                                                Navigator.pop(context);
                                              }
                                            } catch (e) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Failed to exit ride: ${e.toString()}'),
                                                    backgroundColor: AppColors.error,
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                          icon: const Icon(Icons.exit_to_app, color: AppColors.error, size: 20),
                                          label: const Text(
                                            'Exit',
                                            style: TextStyle(color: AppColors.error),
                                          ),
                                        )
                                      else
                                        IconButton(
                                          icon: const Icon(Icons.copy, color: AppColors.textSecondary, size: 20),
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(text: m.phoneNumber));
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text("Copied Phone Number")),
                                            );
                                          },
                                          tooltip: 'Copy phone number',
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                    FutureBuilder<String?>(
                      future: _getEmail(ref),
                      builder: (context, emailSnapshot) {
                        if (emailSnapshot.connectionState == ConnectionState.waiting) {
                          return const SizedBox.shrink();
                        }
                        final currentUserEmail = emailSnapshot.data;
                        final isCurrentUserMember = currentUserEmail != null && 
                            (members.any((member) => member.email == currentUserEmail) || 
                             ride.createdBy == currentUserEmail);
                        
                        if (!isCurrentUserMember) {
                          // Check if user has already sent a request
                          return FutureBuilder(
                            future: ref.read(userNotifierProvider.notifier).getSentRequests(),
                            builder: (context, sentRequestsSnapshot) {
                              if (sentRequestsSnapshot.connectionState == ConnectionState.waiting) {
                                return const SizedBox.shrink();
                              }
                              
                              final sentRequests = sentRequestsSnapshot.data ?? [];
                              final hasSentRequest = sentRequests.any((request) => request.id == ride.id);
                              
                              if (hasSentRequest) {
                                return const SizedBox.shrink(); // Don't show button if request already sent
                              }
                              
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      await ref.read(ridesNotifierProvider.notifier).sendRequest(ride.id);
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Successfully sent request to join the Ride!'),
                                            backgroundColor: AppColors.success,
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Failed to Join Ride: ${e.toString()}'),
                                            backgroundColor: AppColors.error,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                  ),
                                  child: const Text('Send request to join'),
                                ),
                              );
                            },
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}