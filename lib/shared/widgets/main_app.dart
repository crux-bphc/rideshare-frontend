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

class _MainAppState extends ConsumerState<MainApp> {
  @override
  Widget build(BuildContext context) {
    final currentTab = ref.watch(navigationNotifierProvider);
    final navigationNotifier = ref.read(navigationNotifierProvider.notifier);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

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
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 8 : 16,
                  vertical: isMobile ? 6 : 8,
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
                      isMobile,
                    ),
                    _buildNavItem(
                      context,
                      ref,
                      NavigationTab.rides,
                      currentTab,
                      navigationNotifier,
                      Icons.directions_car_filled_outlined,
                      Icons.directions_car,
                      'Rides',
                      isMobile,
                    ),
                    _buildNavItem(
                      context,
                      ref,
                      NavigationTab.inbox,
                      currentTab,
                      navigationNotifier,
                      Icons.inbox_outlined,
                      Icons.inbox,
                      'Inbox',
                      isMobile,
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
                      isMobile,
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
    bool isMobile,
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
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 8 : 16,
          vertical: isMobile ? 8 : 12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? filledIcon : outlinedIcon,
              color: AppColors.primary,
              size: isMobile ? 28 : 34,
            ),
            if (!isMobile) const SizedBox(width: 2),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isSelected && !isMobile
                  ? Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        label,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: isMobile ? 12 : 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
