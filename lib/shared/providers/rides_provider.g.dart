// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rides_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$upcomingRidesHash() => r'f7b931f68df8cb9b9420d4de9ef17bc364b8f21c';

/// See also [upcomingRides].
@ProviderFor(upcomingRides)
final upcomingRidesProvider = AutoDisposeFutureProvider<List<Ride>>.internal(
  upcomingRides,
  name: r'upcomingRidesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$upcomingRidesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpcomingRidesRef = AutoDisposeFutureProviderRef<List<Ride>>;
String _$bookmarkedRidesHash() => r'802836529a21226b56abef874120942b6dd047ab';

/// See also [bookmarkedRides].
@ProviderFor(bookmarkedRides)
final bookmarkedRidesProvider = AutoDisposeFutureProvider<List<Ride>>.internal(
  bookmarkedRides,
  name: r'bookmarkedRidesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bookmarkedRidesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BookmarkedRidesRef = AutoDisposeFutureProviderRef<List<Ride>>;
String _$ridesNotifierHash() => r'2410187c37ea2ecf6d1948abe3c866731b95f89f';

/// See also [RidesNotifier].
@ProviderFor(RidesNotifier)
final ridesNotifierProvider =
    AutoDisposeAsyncNotifierProvider<RidesNotifier, List<Ride>>.internal(
      RidesNotifier.new,
      name: r'ridesNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$ridesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RidesNotifier = AutoDisposeAsyncNotifier<List<Ride>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
