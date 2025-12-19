// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RideRequest _$RideRequestFromJson(Map<String, dynamic> json) => _RideRequest(
  id: (json['id'] as num).toInt(),
  createdBy: json['createdBy'] as String,
  status: json['status'] as String,
  requestSender: json['requestSender'] as String,
  comments: json['comments'] as String?,
  departureStartTime: json['departureStartTime'] == null
      ? null
      : DateTime.parse(json['departureStartTime'] as String),
  departureEndTime: json['departureEndTime'] == null
      ? null
      : DateTime.parse(json['departureEndTime'] as String),
  maxMemberCount: (json['maxMemberCount'] as num?)?.toInt(),
  rideStartLocation: json['rideStartLocation'] as String?,
  rideEndLocation: json['rideEndLocation'] as String?,
);

Map<String, dynamic> _$RideRequestToJson(_RideRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdBy': instance.createdBy,
      'status': instance.status,
      'requestSender': instance.requestSender,
      'comments': instance.comments,
      'departureStartTime': instance.departureStartTime?.toIso8601String(),
      'departureEndTime': instance.departureEndTime?.toIso8601String(),
      'maxMemberCount': instance.maxMemberCount,
      'rideStartLocation': instance.rideStartLocation,
      'rideEndLocation': instance.rideEndLocation,
    };
