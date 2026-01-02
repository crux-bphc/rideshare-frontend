// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileUserDetailsHash() =>
    r'a4c84ee282a2e2e397e7cb457f352875743e29d7';

/// See also [profileUserDetails].
@ProviderFor(profileUserDetails)
final profileUserDetailsProvider = FutureProvider<User?>.internal(
  profileUserDetails,
  name: r'profileUserDetailsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileUserDetailsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProfileUserDetailsRef = FutureProviderRef<User?>;
String _$userNotifierHash() => r'990ab5020ee9d545c8d7ecc3edd534d643dc1ad4';

/// See also [UserNotifier].
@ProviderFor(UserNotifier)
final userNotifierProvider =
    AutoDisposeAsyncNotifierProvider<UserNotifier, User?>.internal(
      UserNotifier.new,
      name: r'userNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UserNotifier = AutoDisposeAsyncNotifier<User?>;
String _$profilePastRidesHash() => r'df2e6c8e46f2c29a3481bf83d9b86ae7e549872e';

/// See also [ProfilePastRides].
@ProviderFor(ProfilePastRides)
final profilePastRidesProvider =
    AsyncNotifierProvider<ProfilePastRides, List<Ride>>.internal(
      ProfilePastRides.new,
      name: r'profilePastRidesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$profilePastRidesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ProfilePastRides = AsyncNotifier<List<Ride>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
