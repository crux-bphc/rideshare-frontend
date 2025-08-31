import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/models/ride_request.dart';
import 'package:rideshare/modules/inbox/widgets/ride_request_card.dart';
import 'package:rideshare/shared/providers/user_provider.dart';
import 'package:rideshare/shared/providers/rides_provider.dart';
import 'package:rideshare/modules/splash/splash_page.dart';


class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  Future<void> _handleRequest(RideRequest req, String status) async {
    await ref.read(ridesNotifierProvider.notifier).manageRequest(
      req.id,
      req.requestSender,
      status,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userNotifier = ref.watch(userNotifierProvider.notifier);
    return FutureBuilder<List<RideRequest>>(
      future: userNotifier.getRequestsReceived(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashPage();
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error loading requests', style: TextStyle(color: Colors.white)));
        }
        final requests = snapshot.data ?? [];
        return Scaffold(
          appBar: AppBar(
            title: const Text("Inbox"),
          ),
          body: ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final req = requests[index];
              return RideCard(
                rideRequest: req,
                onAccept: () => _handleRequest(req, "accepted"),
                onDecline: () => _handleRequest(req, "declined")
              );
            },
          ),
        );
      },
    );
  }
}