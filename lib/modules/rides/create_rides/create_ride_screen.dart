import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rideshare/models/ride.dart';
import 'package:rideshare/modules/rides/search_rides/ridedata_provider.dart';
import 'package:rideshare/shared/providers/rides_provider.dart';
import 'package:rideshare/shared/theme.dart';
import 'package:rideshare/shared/util/datetime_utils.dart';
import 'package:rideshare/shared/providers/navigation_provider.dart';
import 'package:rideshare/modules/rides/widgets/ride_form.dart';

class CreateRideScreen extends ConsumerStatefulWidget {
  final bool isEditing;
  final Ride? ride;
  final String? rideId;
  
  const CreateRideScreen({
    super.key,
    this.isEditing = false,
    this.ride,
    this.rideId,
  });

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (widget.isEditing && widget.ride != null) {
          final ride = widget.ride!;
          startLocationController.text = ride.rideStartLocation ?? '';
          destinationLocationController.text = ride.rideEndLocation ?? '';
          
          if (ride.departureStartTime != null) {
            ref.read(selectedDateProvider.notifier).setDate(ride.departureStartTime!);
            ref.read(departureTimeProvider.notifier).setTime(TimeOfDay.fromDateTime(ride.departureStartTime!));
          }
          
          if (ride.departureEndTime != null) {
            ref.read(arrivalTimeProvider.notifier).setTime(TimeOfDay.fromDateTime(ride.departureEndTime!));
          }
          
          if (ride.maxMemberCount != null) {
            ref.read(seatProvider.notifier).setSeats(ride.maxMemberCount!);
          }
        } else {
          final searchStartLocation = ref.read(searchStartLocationProvider);
          final searchDestinationLocation = ref.read(searchDestinationLocationProvider);
          final currentDate = ref.read(selectedDateProvider);
          final currentDepartureTime = ref.read(departureTimeProvider);
          if (searchStartLocation != null || searchDestinationLocation != null || 
              currentDate != null || currentDepartureTime != null) {
            if (searchStartLocation != null) {
              startLocationController.text = searchStartLocation;
            }
            if (searchDestinationLocation != null) {
              destinationLocationController.text = searchDestinationLocation;
            }
            ref.read(arrivalTimeProvider.notifier).setTime(null);
          }
        }
      }
    });
  }

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
      if (widget.isEditing && widget.rideId != null) {
        await ref
            .read(ridesNotifierProvider.notifier)
            .editRide(
              combineDateAndTime(rideDate, departureTime!)!,
              combineDateAndTime(rideDate, arrivalTime!)!,
              null,
              seats,
              startLocationController.text,
              destinationLocationController.text,
              widget.rideId!,
            );
      } else {
        await ref
            .read(ridesNotifierProvider.notifier)
            .createRide(
              combineDateAndTime(rideDate, departureTime!)!,
              combineDateAndTime(rideDate, arrivalTime!)!,
              null,
              seats,
              startLocationController.text,
              destinationLocationController.text,
            );
      }
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              widget.isEditing ? 'Ride Updated!' : 'Ride Created!',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            content: Text(
              widget.isEditing 
                  ? 'Your ride has been successfully updated.'
                  : 'Your ride has been successfully created.',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (widget.isEditing) {
                    ref
                        .read(navigationNotifierProvider.notifier)
                        .setTab(NavigationTab.home);
                    context.go('/home');
                  } else {
                    _resetForm();
                  }
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
    ref.read(searchStartLocationProvider.notifier).clear();
    ref.read(searchDestinationLocationProvider.notifier).clear();
    GoRouter.of(context).go("/rides/search");
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

  Future<void> _deleteRide() async {
    if (widget.rideId == null) return;
    
    try {
      await ref
          .read(ridesNotifierProvider.notifier)
          .deleteRide(widget.rideId!);
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Ride Deleted!',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            content: const Text(
              'Your ride has been successfully deleted.',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ref
                      .read(navigationNotifierProvider.notifier)
                      .setTab(NavigationTab.home);
                  context.go('/home');
                },
                child: const Text(
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
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Failed to Delete Ride',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            content: Text(
              'Failed to delete ride. Please try again.',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
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
      }
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Delete Ride',
          style: TextStyle(
            color: AppColors.error,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: const Text(
          'Are you sure you want to delete this ride? This action cannot be undone.',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteRide();
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Ride' : 'Create Ride'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: widget.isEditing
            ? [
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: AppColors.error,
                  ),
                  onPressed: _showDeleteConfirmationDialog,
                  tooltip: 'Delete ride',
                ),
              ]
            : null,
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
                  child: Text(
                    widget.isEditing ? 'Update Ride' : 'Create Ride',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
