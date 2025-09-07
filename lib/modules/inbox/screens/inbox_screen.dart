import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/models/ride_request.dart';
import 'package:rideshare/modules/inbox/provider/ride_requests_provider.dart';
import 'package:rideshare/modules/inbox/widgets/ride_request_card.dart';
import 'package:rideshare/modules/splash/splash_page.dart';
import 'package:rideshare/shared/theme.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  Future<void> _handleRequest(WidgetRef ref, RideRequest req, String status) async {
    try {
      await ref.read(rideRequestsAsyncProvider.notifier).handleRequest(
        req.id, 
        req.requestSender, 
        status
      );
      ScaffoldMessenger.of(ref.context).showSnackBar(
        SnackBar(
          content: Text('Request ${status.toLowerCase()} successfully'),
          backgroundColor: status == 'accepted' ? AppColors.success : AppColors.error,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(ref.context).showSnackBar(
        SnackBar(
          content: Text('Failed to update request'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsyncValue = ref.watch(rideRequestsAsyncProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inbox"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(rideRequestsAsyncProvider.notifier).refreshRequests();
            },
          ),
        ],
      ),
      body: requestsAsyncValue.when(
        loading: () => const SplashPage(),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading requests',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(rideRequestsAsyncProvider.notifier).refreshRequests();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (requests) {
          if (requests.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox,
                    size: 64,
                    color: AppColors.accent,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No ride requests',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pull down to refresh',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }
          
          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(rideRequestsAsyncProvider.notifier).refreshRequests();
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final req = requests[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: RideCard(
                    rideRequest: req,
                    onAccept: req.status == 'pending' 
                        ? () => _handleRequest(ref, req, "accepted")
                        : null,
                    onDecline: req.status == 'pending'
                        ? () => _handleRequest(ref, req, "declined") 
                        : null,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}