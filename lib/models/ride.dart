import 'package:freezed_annotation/freezed_annotation.dart';

part 'ride.freezed.dart';
part 'ride.g.dart';

@freezed
abstract class Ride with _$Ride {
  const factory Ride({
    required int id,
    required String createdBy,
    String? comments,
    DateTime? departureStartTime,
    DateTime? departureEndTime,
    int? maxMemberCount,
    String? rideStartLocation,
    String? rideEndLocation,
  }) = _Ride;

  factory Ride.fromJson(Map<String, dynamic> json) => _$RideFromJson(json);
}