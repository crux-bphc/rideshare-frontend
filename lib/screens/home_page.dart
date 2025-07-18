import 'package:flutter/material.dart';
import 'package:rideshare/widgets/custom_elevated_button.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // final authProvider = GetIt.instance<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: const Text('RideShare'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.logout, color: Colors.white), // White icon
      //       onPressed: () {
      //         authProvider.logout();
      //       },
      //       tooltip: 'Logout',
      //     ),
      //   ],
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
                children: <TextSpan>[
                  TextSpan(text: 'Ride', style: TextStyle(color: Colors.white)),
                  TextSpan(text: 'share.', style: TextStyle(color: Color(0xFF777FE4))),
                ],
              ),
            ),
            SizedBox(height: 50),
            Image.asset(
              'assets/logo.png',
              height: 200,
            ),
            SizedBox(height: 20),
            SizedBox(height: 30),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: CustomElevatedButton(
                onPressed: () {
                  //todo: implement search
                },
                text: 'Search available rides',
                icon: const Icon(Icons.search),
                bgColor: const Color(0xFF373b46),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: CustomElevatedButton(
                onPressed: () {
                  //todo: implement view rides
                },
                text: 'Your rides',
                icon: const Icon(Icons.directions_car),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
