import 'package:flutter/material.dart';
import 'package:rideshare/shared/theme.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
    _animation = Tween<double>(
      begin: 0.5,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.scale(scale: _animation.value, child: child);
              },
              child: Image.asset(
                'assets/logo.png',
                height: 200,
              ),
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
                  backgroundColor: WidgetStateProperty.all<Color>(
                    Color(0xFF373b46),
                  ),
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
                style: Theme.of(context).elevatedButtonTheme.style,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
