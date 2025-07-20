import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
               text: TextSpan(
                 style: Theme.of(context).textTheme.displayLarge,
                 children: <TextSpan>[
                   TextSpan(text: 'Ride', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                   TextSpan(text: 'share.', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                 ],
               ),
             ),
            SizedBox(height: 40),
            Image.asset(
              'assets/logo.png',
              height: 200,
            ),
            SizedBox(height: 20),
            SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton.icon(
                onPressed: () {
                  //todo: implement search
                },
                label: const Text('Search available rides'),
                icon: const Icon(Icons.search),
                style: Theme.of(context).elevatedButtonTheme.style,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton.icon(
                onPressed: () {
                  //todo: implement view rides
                },
                label: const Text('Your rides'),
                icon: const Icon(Icons.directions_car),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
