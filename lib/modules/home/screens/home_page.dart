import 'package:flutter/material.dart';
import 'package:rideshare/shared/theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.displayLarge,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Ride',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  TextSpan(
                    text: 'share.',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Image.asset(
              'assets/logo.png',
              height: 200,
            ),
            SizedBox(height: size.height * 0.05),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton.icon(
                onPressed: () {
                  //todo: implement search
                },
                label: const Text('Search available rides'),
                icon: const Icon(Icons.search),
                style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                  backgroundColor: WidgetStateProperty.all<Color>(Color(0xFF373b46)),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.015),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton.icon(
                onPressed: () {
                  //todo: implement view rides
                },
                label: const Text('Your rides'),
                icon: const Icon(Icons.directions_car),
                style: Theme.of(context).elevatedButtonTheme.style
              ),
            ),
          ],
        ),
      ),
    );
  }
}
