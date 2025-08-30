import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rideshare/models/ride.dart';
import 'package:rideshare/modules/rides/widgets/date_picker.dart';
import 'package:rideshare/modules/rides/widgets/time_picker.dart';
import 'package:rideshare/modules/rides/search_rides/ridedata_provider.dart';
import 'package:rideshare/shared/providers/rides_provider.dart';
import 'package:rideshare/shared/theme.dart';
import 'package:rideshare/shared/util/datetime_utils.dart';

import '../../../shared/providers/navigation_provider.dart';
import '../widgets/location_path_input.dart';
import '../widgets/seat_selector.dart';
import '../widgets/styled_input_container.dart';
import '../widgets/time_input.dart';

class SearchRidesScreen extends ConsumerStatefulWidget {
  const SearchRidesScreen({super.key});

  @override
  ConsumerState<SearchRidesScreen> createState() => _SearchRidesScreenState();
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _SearchRidesScreenState extends ConsumerState<SearchRidesScreen> {
  late final TextEditingController startLocationController;
  late final TextEditingController destinationLocationController;

  String? startLocationError;
  String? destinationLocationError;
  String? dateError;
  String? timeError;

  @override
  void initState() {
    super.initState();
    startLocationController = TextEditingController();
    destinationLocationController = TextEditingController();
  }

  @override
  void dispose() {
    startLocationController.dispose();
    destinationLocationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final currentDate = ref.read(selectedDateProvider);
    final picked = await showCustomDatePicker(
      context,
      initialDate: currentDate,
    );
    if (picked != null) {
      ref.read(selectedDateProvider.notifier).setDate(picked);
    }
  }

  Future<void> _selectDepartureTime() async {
    final picked = await showCustomTimePicker(
      context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      ref.read(departureTimeProvider.notifier).setTime(picked);
      ref.read(arrivalTimeProvider.notifier).setTime(null);
    }
  }

  Future<void> _selectArrivalTime() async {
    final picked = await showCustomTimePicker(
      context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      ref.read(arrivalTimeProvider.notifier).setTime(picked);
    }
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
      print('Error creating ride: $e');
    }
    return [];
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
    });
    if (startLocationError == null &&
        destinationLocationError == null &&
        dateError == null &&
        timeError == null) {
      final rides = await _searchRide();
      _resetForm();
      GoRouter.of(context).go('/rides/available', extra: rides);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(selectedDateProvider);
    ref.watch(departureTimeProvider);
    ref.watch(arrivalTimeProvider);

    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Rides'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
    
            ref.read(navigationNotifierProvider.notifier).setTab(NavigationTab.home);
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
              LocationPathInput(
                startController: startLocationController,
                endController: destinationLocationController,
                startError: startLocationError,
                endError: destinationLocationError,
              ),

              const SizedBox(height: 24),
              SectionHeader(title: 'Ride Date'),
              const SizedBox(height: 16),
              RideDateTextField(onTap: _selectDate, errorText: dateError),
              const SizedBox(height: 24),
              SectionHeader(title: 'Departure window'),
              const SizedBox(height: 16),
              TimeWindowInput(
                onDepartureTap: _selectDepartureTime,
                onArrivalTap: _selectArrivalTime,
                errorText: timeError,
              ),

              if (timeError != null) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    timeError!,
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),
              SectionHeader(title: 'Seats Required'),
              const SizedBox(height: 16),
              const SeatSelection(),

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
