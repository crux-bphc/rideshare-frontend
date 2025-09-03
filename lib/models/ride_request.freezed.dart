// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ride_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RideRequest {

 int get id; String get createdBy; String get status; String get requestSender; String? get comments; DateTime? get departureStartTime; DateTime? get departureEndTime; int? get maxMemberCount; String? get rideStartLocation; String? get rideEndLocation;
/// Create a copy of RideRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RideRequestCopyWith<RideRequest> get copyWith => _$RideRequestCopyWithImpl<RideRequest>(this as RideRequest, _$identity);

  /// Serializes this RideRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RideRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.status, status) || other.status == status)&&(identical(other.requestSender, requestSender) || other.requestSender == requestSender)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.departureStartTime, departureStartTime) || other.departureStartTime == departureStartTime)&&(identical(other.departureEndTime, departureEndTime) || other.departureEndTime == departureEndTime)&&(identical(other.maxMemberCount, maxMemberCount) || other.maxMemberCount == maxMemberCount)&&(identical(other.rideStartLocation, rideStartLocation) || other.rideStartLocation == rideStartLocation)&&(identical(other.rideEndLocation, rideEndLocation) || other.rideEndLocation == rideEndLocation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdBy,status,requestSender,comments,departureStartTime,departureEndTime,maxMemberCount,rideStartLocation,rideEndLocation);

@override
String toString() {
  return 'RideRequest(id: $id, createdBy: $createdBy, status: $status, requestSender: $requestSender, comments: $comments, departureStartTime: $departureStartTime, departureEndTime: $departureEndTime, maxMemberCount: $maxMemberCount, rideStartLocation: $rideStartLocation, rideEndLocation: $rideEndLocation)';
}


}

/// @nodoc
abstract mixin class $RideRequestCopyWith<$Res>  {
  factory $RideRequestCopyWith(RideRequest value, $Res Function(RideRequest) _then) = _$RideRequestCopyWithImpl;
@useResult
$Res call({
 int id, String createdBy, String status, String requestSender, String? comments, DateTime? departureStartTime, DateTime? departureEndTime, int? maxMemberCount, String? rideStartLocation, String? rideEndLocation
});




}
/// @nodoc
class _$RideRequestCopyWithImpl<$Res>
    implements $RideRequestCopyWith<$Res> {
  _$RideRequestCopyWithImpl(this._self, this._then);

  final RideRequest _self;
  final $Res Function(RideRequest) _then;

/// Create a copy of RideRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdBy = null,Object? status = null,Object? requestSender = null,Object? comments = freezed,Object? departureStartTime = freezed,Object? departureEndTime = freezed,Object? maxMemberCount = freezed,Object? rideStartLocation = freezed,Object? rideEndLocation = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,requestSender: null == requestSender ? _self.requestSender : requestSender // ignore: cast_nullable_to_non_nullable
as String,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String?,departureStartTime: freezed == departureStartTime ? _self.departureStartTime : departureStartTime // ignore: cast_nullable_to_non_nullable
as DateTime?,departureEndTime: freezed == departureEndTime ? _self.departureEndTime : departureEndTime // ignore: cast_nullable_to_non_nullable
as DateTime?,maxMemberCount: freezed == maxMemberCount ? _self.maxMemberCount : maxMemberCount // ignore: cast_nullable_to_non_nullable
as int?,rideStartLocation: freezed == rideStartLocation ? _self.rideStartLocation : rideStartLocation // ignore: cast_nullable_to_non_nullable
as String?,rideEndLocation: freezed == rideEndLocation ? _self.rideEndLocation : rideEndLocation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RideRequest].
extension RideRequestPatterns on RideRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RideRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RideRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RideRequest value)  $default,){
final _that = this;
switch (_that) {
case _RideRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RideRequest value)?  $default,){
final _that = this;
switch (_that) {
case _RideRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String createdBy,  String status,  String requestSender,  String? comments,  DateTime? departureStartTime,  DateTime? departureEndTime,  int? maxMemberCount,  String? rideStartLocation,  String? rideEndLocation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RideRequest() when $default != null:
return $default(_that.id,_that.createdBy,_that.status,_that.requestSender,_that.comments,_that.departureStartTime,_that.departureEndTime,_that.maxMemberCount,_that.rideStartLocation,_that.rideEndLocation);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String createdBy,  String status,  String requestSender,  String? comments,  DateTime? departureStartTime,  DateTime? departureEndTime,  int? maxMemberCount,  String? rideStartLocation,  String? rideEndLocation)  $default,) {final _that = this;
switch (_that) {
case _RideRequest():
return $default(_that.id,_that.createdBy,_that.status,_that.requestSender,_that.comments,_that.departureStartTime,_that.departureEndTime,_that.maxMemberCount,_that.rideStartLocation,_that.rideEndLocation);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String createdBy,  String status,  String requestSender,  String? comments,  DateTime? departureStartTime,  DateTime? departureEndTime,  int? maxMemberCount,  String? rideStartLocation,  String? rideEndLocation)?  $default,) {final _that = this;
switch (_that) {
case _RideRequest() when $default != null:
return $default(_that.id,_that.createdBy,_that.status,_that.requestSender,_that.comments,_that.departureStartTime,_that.departureEndTime,_that.maxMemberCount,_that.rideStartLocation,_that.rideEndLocation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RideRequest implements RideRequest {
  const _RideRequest({required this.id, required this.createdBy, required this.status, required this.requestSender, this.comments, this.departureStartTime, this.departureEndTime, this.maxMemberCount, this.rideStartLocation, this.rideEndLocation});
  factory _RideRequest.fromJson(Map<String, dynamic> json) => _$RideRequestFromJson(json);

@override final  int id;
@override final  String createdBy;
@override final  String status;
@override final  String requestSender;
@override final  String? comments;
@override final  DateTime? departureStartTime;
@override final  DateTime? departureEndTime;
@override final  int? maxMemberCount;
@override final  String? rideStartLocation;
@override final  String? rideEndLocation;

/// Create a copy of RideRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RideRequestCopyWith<_RideRequest> get copyWith => __$RideRequestCopyWithImpl<_RideRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RideRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RideRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.status, status) || other.status == status)&&(identical(other.requestSender, requestSender) || other.requestSender == requestSender)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.departureStartTime, departureStartTime) || other.departureStartTime == departureStartTime)&&(identical(other.departureEndTime, departureEndTime) || other.departureEndTime == departureEndTime)&&(identical(other.maxMemberCount, maxMemberCount) || other.maxMemberCount == maxMemberCount)&&(identical(other.rideStartLocation, rideStartLocation) || other.rideStartLocation == rideStartLocation)&&(identical(other.rideEndLocation, rideEndLocation) || other.rideEndLocation == rideEndLocation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdBy,status,requestSender,comments,departureStartTime,departureEndTime,maxMemberCount,rideStartLocation,rideEndLocation);

@override
String toString() {
  return 'RideRequest(id: $id, createdBy: $createdBy, status: $status, requestSender: $requestSender, comments: $comments, departureStartTime: $departureStartTime, departureEndTime: $departureEndTime, maxMemberCount: $maxMemberCount, rideStartLocation: $rideStartLocation, rideEndLocation: $rideEndLocation)';
}


}

/// @nodoc
abstract mixin class _$RideRequestCopyWith<$Res> implements $RideRequestCopyWith<$Res> {
  factory _$RideRequestCopyWith(_RideRequest value, $Res Function(_RideRequest) _then) = __$RideRequestCopyWithImpl;
@override @useResult
$Res call({
 int id, String createdBy, String status, String requestSender, String? comments, DateTime? departureStartTime, DateTime? departureEndTime, int? maxMemberCount, String? rideStartLocation, String? rideEndLocation
});




}
/// @nodoc
class __$RideRequestCopyWithImpl<$Res>
    implements _$RideRequestCopyWith<$Res> {
  __$RideRequestCopyWithImpl(this._self, this._then);

  final _RideRequest _self;
  final $Res Function(_RideRequest) _then;

/// Create a copy of RideRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdBy = null,Object? status = null,Object? requestSender = null,Object? comments = freezed,Object? departureStartTime = freezed,Object? departureEndTime = freezed,Object? maxMemberCount = freezed,Object? rideStartLocation = freezed,Object? rideEndLocation = freezed,}) {
  return _then(_RideRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,requestSender: null == requestSender ? _self.requestSender : requestSender // ignore: cast_nullable_to_non_nullable
as String,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String?,departureStartTime: freezed == departureStartTime ? _self.departureStartTime : departureStartTime // ignore: cast_nullable_to_non_nullable
as DateTime?,departureEndTime: freezed == departureEndTime ? _self.departureEndTime : departureEndTime // ignore: cast_nullable_to_non_nullable
as DateTime?,maxMemberCount: freezed == maxMemberCount ? _self.maxMemberCount : maxMemberCount // ignore: cast_nullable_to_non_nullable
as int?,rideStartLocation: freezed == rideStartLocation ? _self.rideStartLocation : rideStartLocation // ignore: cast_nullable_to_non_nullable
as String?,rideEndLocation: freezed == rideEndLocation ? _self.rideEndLocation : rideEndLocation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
