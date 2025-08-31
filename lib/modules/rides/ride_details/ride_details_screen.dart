import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/models/ride.dart';
import 'package:rideshare/models/user.dart';
import 'package:rideshare/modules/rides/ride_details/widgets/member_card.dart';
import 'package:rideshare/modules/rides/ride_details/widgets/route_icon.dart';
import 'package:rideshare/modules/splash/splash_page.dart';
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
                  onPressed: () => Navigator.pop(context),
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
                      ...members.map((m) => MemberCard(member: m)),
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
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                try{
                                  ref.read(ridesNotifierProvider.notifier).sendRequest(ride.id);
                                  const snackBar = SnackBar(content: Text('Succesfully joined the Ride!'), backgroundColor: AppColors.success,);
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                                catch(e){
                                  const snackBar = SnackBar(content: Text('Failed to Join Ride'), backgroundColor: AppColors.error,);
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                              ),
                              child: const Text('Send request to join'),
                            ),
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