import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rideshare/shared/providers/navigation_provider.dart';
import 'package:rideshare/shared/theme.dart';

class MainApp extends ConsumerStatefulWidget {
  final Widget? child;

  const MainApp({super.key, this.child});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.value = 1.0;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = ref.watch(navigationNotifierProvider);
    final navigationNotifier = ref.read(navigationNotifierProvider.notifier);
    final currentIndex = currentTab.index;

    if (currentIndex != _previousIndex) {
      _animationController.forward(from: 0.0);
      _previousIndex = currentIndex;
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.navbar,
        ),
        child: SafeArea(  
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      context,
                      ref,
                      NavigationTab.home,
                      currentTab,
                      navigationNotifier,
                      Icons.home_outlined,
                      Icons.home,
                      'Home',
                    ),
                    _buildNavItem(
                      context,
                      ref,
                      NavigationTab.rides,
                      currentTab,
                      navigationNotifier,
                      Icons.inbox_outlined,
                      Icons.inbox,
                      'Inbox',
                    ),
                    _buildNavItem(
                      context,
                      ref,
                      NavigationTab.inbox,
                      currentTab,
                      navigationNotifier,
                      Icons.directions_car_filled_outlined,
                      Icons.directions_car,
                      'Rides',
                    ),
                    _buildNavItem(
                      context,
                      ref,
                      NavigationTab.profile,
                      currentTab,
                      navigationNotifier,
                      Icons.account_circle_outlined,
                      Icons.account_circle,
                      'Profile',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    WidgetRef ref,
    NavigationTab tab,
    NavigationTab currentTab,
    dynamic navigationNotifier,
    IconData outlinedIcon,
    IconData filledIcon,
    String label,
  ) {
    final isSelected = currentTab == tab;

    return GestureDetector(
      onTap: () {
        navigationNotifier.setTab(tab);
        context.go(navigationNotifier.getCurrentRoute());
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? filledIcon : outlinedIcon,
                key: ValueKey(isSelected),
                color: isSelected
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.8),
                size: 34,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(10 * (1 - _fadeAnimation.value), 0),
                      child: Text(
                        label,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
