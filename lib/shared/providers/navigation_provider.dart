import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'package:rideshare/shared/providers/navigation_provider.g.dart';

enum NavigationTab {
  home,
  rides,
  inbox,
  profile,
}

@riverpod
class NavigationNotifier extends _$NavigationNotifier {
  @override
  NavigationTab build() {
    return NavigationTab.home;
  }

  void setTab(NavigationTab tab) {
    state = tab;
  }

  String getCurrentRoute() {
    switch (state) {
      case NavigationTab.home:
        return '/home';
      case NavigationTab.rides:
        return '/rides';
      case NavigationTab.inbox:
        return '/inbox';
      case NavigationTab.profile:
        return '/profile';
    }
  }
}
