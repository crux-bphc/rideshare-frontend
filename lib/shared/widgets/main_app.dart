import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rideshare/shared/providers/navigation_provider.dart';
import 'package:rideshare/shared/theme.dart';

class MainApp extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;
  final Widget? child;

  const MainApp({super.key, required this.navigationShell, this.child});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

final _navIndexProvider = Provider.family<int, StatefulNavigationShell>((
  ref,
  shell,
) {
  return shell.currentIndex;
});

class _MainAppState extends ConsumerState<MainApp> {
  @override
  Widget build(BuildContext context) {
    // final currentTab = ref.watch(navigationNotifierProvider);
    // final navigationNotifier = ref.read(navigationNotifierProvider.notifier);

    ref.listen<int>(
      _navIndexProvider(widget.navigationShell),
      (previous, next) {
        ref
            .read(navigationNotifierProvider.notifier)
            .setTab(NavigationTab.values[next]);
      },
    );

    final currentTab =
        NavigationTab.values[widget.navigationShell.currentIndex];

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
                      Icons.home_outlined,
                      Icons.home,
                      'Home',
                    ),
                    _buildNavItem(
                      context,
                      ref,
                      NavigationTab.rides,
                      currentTab,
                      Icons.directions_car_filled_outlined,
                      Icons.directions_car,
                      'Rides',
                    ),
                    _buildNavItem(
                      context,
                      ref,
                      NavigationTab.inbox,
                      currentTab,
                      Icons.inbox_outlined,
                      Icons.inbox,
                      'Inbox',
                    ),
                    _buildNavItem(
                      context,
                      ref,
                      NavigationTab.profile,
                      currentTab,
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
    IconData outlinedIcon,
    IconData filledIcon,
    String label,
  ) {
    final isSelected = currentTab == tab;

    return GestureDetector(
      onTap: () {
        widget.navigationShell.goBranch(
          tab.index,
          initialLocation: true,
        );
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
            Icon(
              isSelected ? filledIcon : outlinedIcon,
              color: AppColors.primary,
              size: 34,
            ),
            const SizedBox(width: 2),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isSelected
                  ? Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        label,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
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
