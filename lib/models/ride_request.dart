import 'package:freezed_annotation/freezed_annotation.dart';

part 'ride_request.freezed.dart';
part 'ride_request.g.dart';

@freezed
abstract class RideRequest with _$RideRequest {
  const factory RideRequest({
    required int id,
    required String createdBy,
    required String status,
    required String requestSender,
    String? comments,
    DateTime? departureStartTime,
    DateTime? departureEndTime,
    int? maxMemberCount,
    String? rideStartLocation,
    String? rideEndLocation,
  }) = _RideRequest;

  factory RideRequest.fromJson(Map<String, dynamic> json) =>
      _$RideRequestFromJson(json);
}
