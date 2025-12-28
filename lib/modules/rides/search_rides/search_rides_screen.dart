import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rideshare/models/ride.dart';
import 'package:rideshare/modules/rides/search_rides/ridedata_provider.dart';
import 'package:rideshare/modules/rides/widgets/styled_input_container.dart';
import 'package:rideshare/shared/providers/rides_provider.dart';
import 'package:rideshare/shared/theme.dart';
import 'package:rideshare/shared/util/datetime_utils.dart';

import 'package:rideshare/shared/providers/navigation_provider.dart';
import 'package:rideshare/modules/rides/widgets/ride_form.dart';

class SearchRidesScreen extends ConsumerStatefulWidget {
  const SearchRidesScreen({super.key});

  @override
  ConsumerState<SearchRidesScreen> createState() => _SearchRidesScreenState();
}

class _SearchRidesScreenState extends ConsumerState<SearchRidesScreen> {
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

  Future<List<Ride>> _searchRide() async {
    final rideDate = ref.read(selectedDateProvider);
    final departureTime = ref.read(departureTimeProvider);
    final arrivalTime = ref.read(arrivalTimeProvider);

    try {
      return ref
          .read(rideServiceProvider)
          .searchRides(
            startLocationController.text,
            destinationLocationController.text,
            combineDateAndTime(rideDate, departureTime),
            combineDateAndTime(rideDate, arrivalTime),
          );
    } catch (e) {
      return [];
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

  void _validateAndSearch() async {
    setState(() {
      startLocationError = startLocationController.text.trim().isEmpty
          ? "Please enter Start Location"
          : null;
      destinationLocationError =
          destinationLocationController.text.trim().isEmpty
          ? "Please enter Destination"
          : null;
      dateError = ref.read(selectedDateProvider) == null
          ? "Please select Ride Date"
          : null;
      final departureTime = ref.read(departureTimeProvider);
      final arrivalTime = ref.read(arrivalTimeProvider);
      timeError = (departureTime == null && arrivalTime == null)
          ? "Select Departure or Arrival Time"
          : null;

      seatsError = null;

      if (departureTime != null &&
          arrivalTime != null &&
          departureTime.isAfter(arrivalTime)) {
        timeError = "Departure time cannot be after arrival time";
      }
    });
      if (startLocationError == null &&
        destinationLocationError == null &&
        dateError == null &&
        timeError == null &&
        seatsError == null) {
      ref.read(searchStartLocationProvider.notifier).setLocation(startLocationController.text.trim());
      ref.read(searchDestinationLocationProvider.notifier).setLocation(destinationLocationController.text.trim());
      
      final rides = await _searchRide();
      if (mounted) {
        GoRouter.of(context).go('/rides/available', extra: rides);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Rides'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref
                .read(navigationNotifierProvider.notifier)
                .setTab(NavigationTab.home);
            context.go('/home');
          },
        ),
      ),
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
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
                showSeatsSelector: false,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _validateAndSearch,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Available rides',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RideDateTextField extends ConsumerWidget {
  final VoidCallback onTap;
  final String? errorText;
  const RideDateTextField({super.key, required this.onTap, this.errorText});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rideDate = ref.watch(selectedDateProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StyledInputContainer(
          title: 'Enter Date',
          value: formatDate(rideDate),
          icon: Icons.calendar_today,
          onTap: onTap,
          hasError: errorText != null,
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text(
              errorText!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
