import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rideshare/modules/rides/search_rides/ridedata_provider.dart';
import 'package:rideshare/shared/providers/rides_provider.dart';
import 'package:rideshare/shared/theme.dart';
import 'package:rideshare/shared/util/datetime_utils.dart';

import '../../../shared/providers/navigation_provider.dart';
import '../widgets/ride_form.dart';

class CreateRideScreen extends ConsumerStatefulWidget {
  const CreateRideScreen({super.key});

  @override
  ConsumerState<CreateRideScreen> createState() => _CreateRideScreenState();
}

class _CreateRideScreenState extends ConsumerState<CreateRideScreen> {
  late final TextEditingController startLocationController =
      TextEditingController();
  late final TextEditingController destinationLocationController =
      TextEditingController();

  String? startLocationError;
  String? destinationLocationError;
  String? dateError;
  String? timeError;
  String? seatsError;

  @override
  void dispose() {
    startLocationController.dispose();
    destinationLocationController.dispose();
    super.dispose();
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
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Ride Created!',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            content: Text(
              'Your ride has been successfully created.',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _resetForm();
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
        ref
            .read(navigationNotifierProvider.notifier)
            .setTab(NavigationTab.home);
        context.go('/home');
      }
    } catch (e) {
      throw Exception("Error Creating Ride");
    }
  }

  void _resetForm() {
    startLocationController.clear();
    destinationLocationController.clear();
    ref.read(selectedDateProvider.notifier).setDate(null);
    ref.read(departureTimeProvider.notifier).setTime(null);
    ref.read(arrivalTimeProvider.notifier).setTime(null);
    ref.read(seatProvider.notifier).resetSeats();
  }

  bool get _canCreateRide {
    final rideDate = ref.watch(selectedDateProvider);
    final departureTime = ref.watch(departureTimeProvider);
    final arrivalTime = ref.watch(arrivalTimeProvider);
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
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Create Ride'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RideForm(
                startLocationController: startLocationController,
                destinationLocationController: destinationLocationController,
                startLocationError: startLocationError,
                destinationLocationError: destinationLocationError,
                dateError: dateError,
                timeError: timeError,
                seatsError: seatsError,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canCreateRide ? _createRide : null,
                  style: Theme.of(context).elevatedButtonTheme.style,
                  child: const Text(
                    'Create Ride',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
