import 'package:flutter/material.dart';
import 'package:rideshare/modules/inbox/models/ride.dart';
import 'package:rideshare/modules/inbox/widgets/ride_card.dart';


class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> requests = [
      {
        "title": "ALICE JAYSON requested to join",
        "subtitle": "Campus - Airport",
        "timeAgo": "2 hr ago",
        "date": "6th Jun",
        "endTime": "12:30",
        "startTime": "12:00",
        "stop": "Sainakpuri",
        "seats": "4 seats",
        "status": "pending"
      },
      {
        "title": "TO: ALICE JAYSON",
        "subtitle": "Campus - Airport",
        "timeAgo": "3 hr ago",
        "date": "6th Jun",
        "endTime": "12:30",
        "startTime": "12:00",
        "stop": "Sainakpuri",
        "seats": "4 seats",
        "status": "accepted"
      },
      {
        "title": "TO: ALICE JAYSON",
        "subtitle": "Campus - Airport",
        "timeAgo": "2 hr ago",
        "date": "7th Jun",
        "endTime": "12:30",
        "startTime": "12:00",
        "stop": "Sainakpuri",
        "seats": "4 seats",
        "status": "declined"
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inbox"),
      ),
      body: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final req = requests[index];
          return RideCard(
            ride: Ride(title: req["title"], subtitle: req["subtitle"], timeAgo: req["timeAgo"], date: req["date"], endTime: req["endTime"],
             startTime: req["startTime"], stop: req["stop"], seats: req["seats"], status: req["status"],),
            height: 150,
            width: 150,
            fontSizeSubtitle: 14,
            fontSizeTitle: 18,
            margin: const EdgeInsets.all(8),
            borderThickness: 1,
            borderRadius: 6,
            onAccept: () => print("Accepted ${req["title"]}"),
            onDecline: () => print("Declined ${req["title"]}"),
          );
        },
      ),
    );
  }
}
