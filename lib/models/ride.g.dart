// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Ride _$RideFromJson(Map<String, dynamic> json) => _Ride(
  id: (json['id'] as num).toInt(),
  createdBy: json['createdBy'] as String,
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
  isBookmarked: json['isBookmarked'] as bool?,
);

Map<String, dynamic> _$RideToJson(_Ride instance) => <String, dynamic>{
  'id': instance.id,
  'createdBy': instance.createdBy,
  'comments': instance.comments,
  'departureStartTime': instance.departureStartTime?.toIso8601String(),
  'departureEndTime': instance.departureEndTime?.toIso8601String(),
  'maxMemberCount': instance.maxMemberCount,
  'rideStartLocation': instance.rideStartLocation,
  'rideEndLocation': instance.rideEndLocation,
  'isBookmarked': instance.isBookmarked,
};
