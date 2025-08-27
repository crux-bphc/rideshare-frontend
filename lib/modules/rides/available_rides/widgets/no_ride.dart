import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class noRideScreen extends StatelessWidget {
  const noRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "No Rides Avaiable. Create a New one",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(
            height: 14,
          ),
          ElevatedButton(
            onPressed: () {
              GoRouter.of(context).go('/rides/create');
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Create Ride',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
