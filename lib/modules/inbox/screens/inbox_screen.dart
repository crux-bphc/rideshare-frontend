import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/models/ride_request.dart';
import 'package:rideshare/modules/inbox/widgets/ride_request_card.dart';
import 'package:rideshare/shared/providers/user_provider.dart';
import 'package:rideshare/modules/splash/splash_page.dart';


class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
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
                    onAccept: () => print("Accepted request ${req.id}"),
                    onDecline: () => print("Declined request ${req.id}"),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}