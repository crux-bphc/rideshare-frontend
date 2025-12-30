// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ride.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Ride {

 int get id; String get createdBy; String? get comments; DateTime? get departureStartTime; DateTime? get departureEndTime; int? get maxMemberCount; String? get rideStartLocation; String? get rideEndLocation; bool? get isBookmarked;
/// Create a copy of Ride
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RideCopyWith<Ride> get copyWith => _$RideCopyWithImpl<Ride>(this as Ride, _$identity);

  /// Serializes this Ride to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Ride&&(identical(other.id, id) || other.id == id)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.departureStartTime, departureStartTime) || other.departureStartTime == departureStartTime)&&(identical(other.departureEndTime, departureEndTime) || other.departureEndTime == departureEndTime)&&(identical(other.maxMemberCount, maxMemberCount) || other.maxMemberCount == maxMemberCount)&&(identical(other.rideStartLocation, rideStartLocation) || other.rideStartLocation == rideStartLocation)&&(identical(other.rideEndLocation, rideEndLocation) || other.rideEndLocation == rideEndLocation)&&(identical(other.isBookmarked, isBookmarked) || other.isBookmarked == isBookmarked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdBy,comments,departureStartTime,departureEndTime,maxMemberCount,rideStartLocation,rideEndLocation,isBookmarked);

@override
String toString() {
  return 'Ride(id: $id, createdBy: $createdBy, comments: $comments, departureStartTime: $departureStartTime, departureEndTime: $departureEndTime, maxMemberCount: $maxMemberCount, rideStartLocation: $rideStartLocation, rideEndLocation: $rideEndLocation, isBookmarked: $isBookmarked)';
}


}

/// @nodoc
abstract mixin class $RideCopyWith<$Res>  {
  factory $RideCopyWith(Ride value, $Res Function(Ride) _then) = _$RideCopyWithImpl;
@useResult
$Res call({
 int id, String createdBy, String? comments, DateTime? departureStartTime, DateTime? departureEndTime, int? maxMemberCount, String? rideStartLocation, String? rideEndLocation, bool? isBookmarked
});




}
/// @nodoc
class _$RideCopyWithImpl<$Res>
    implements $RideCopyWith<$Res> {
  _$RideCopyWithImpl(this._self, this._then);

  final Ride _self;
  final $Res Function(Ride) _then;

/// Create a copy of Ride
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdBy = null,Object? comments = freezed,Object? departureStartTime = freezed,Object? departureEndTime = freezed,Object? maxMemberCount = freezed,Object? rideStartLocation = freezed,Object? rideEndLocation = freezed,Object? isBookmarked = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String?,departureStartTime: freezed == departureStartTime ? _self.departureStartTime : departureStartTime // ignore: cast_nullable_to_non_nullable
as DateTime?,departureEndTime: freezed == departureEndTime ? _self.departureEndTime : departureEndTime // ignore: cast_nullable_to_non_nullable
as DateTime?,maxMemberCount: freezed == maxMemberCount ? _self.maxMemberCount : maxMemberCount // ignore: cast_nullable_to_non_nullable
as int?,rideStartLocation: freezed == rideStartLocation ? _self.rideStartLocation : rideStartLocation // ignore: cast_nullable_to_non_nullable
as String?,rideEndLocation: freezed == rideEndLocation ? _self.rideEndLocation : rideEndLocation // ignore: cast_nullable_to_non_nullable
as String?,isBookmarked: freezed == isBookmarked ? _self.isBookmarked : isBookmarked // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [Ride].
extension RidePatterns on Ride {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Ride value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Ride() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Ride value)  $default,){
final _that = this;
switch (_that) {
case _Ride():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Ride value)?  $default,){
final _that = this;
switch (_that) {
case _Ride() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String createdBy,  String? comments,  DateTime? departureStartTime,  DateTime? departureEndTime,  int? maxMemberCount,  String? rideStartLocation,  String? rideEndLocation,  bool? isBookmarked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Ride() when $default != null:
return $default(_that.id,_that.createdBy,_that.comments,_that.departureStartTime,_that.departureEndTime,_that.maxMemberCount,_that.rideStartLocation,_that.rideEndLocation,_that.isBookmarked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String createdBy,  String? comments,  DateTime? departureStartTime,  DateTime? departureEndTime,  int? maxMemberCount,  String? rideStartLocation,  String? rideEndLocation,  bool? isBookmarked)  $default,) {final _that = this;
switch (_that) {
case _Ride():
return $default(_that.id,_that.createdBy,_that.comments,_that.departureStartTime,_that.departureEndTime,_that.maxMemberCount,_that.rideStartLocation,_that.rideEndLocation,_that.isBookmarked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String createdBy,  String? comments,  DateTime? departureStartTime,  DateTime? departureEndTime,  int? maxMemberCount,  String? rideStartLocation,  String? rideEndLocation,  bool? isBookmarked)?  $default,) {final _that = this;
switch (_that) {
case _Ride() when $default != null:
return $default(_that.id,_that.createdBy,_that.comments,_that.departureStartTime,_that.departureEndTime,_that.maxMemberCount,_that.rideStartLocation,_that.rideEndLocation,_that.isBookmarked);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Ride implements Ride {
  const _Ride({required this.id, required this.createdBy, this.comments, this.departureStartTime, this.departureEndTime, this.maxMemberCount, this.rideStartLocation, this.rideEndLocation, this.isBookmarked});
  factory _Ride.fromJson(Map<String, dynamic> json) => _$RideFromJson(json);

@override final  int id;
@override final  String createdBy;
@override final  String? comments;
@override final  DateTime? departureStartTime;
@override final  DateTime? departureEndTime;
@override final  int? maxMemberCount;
@override final  String? rideStartLocation;
@override final  String? rideEndLocation;
@override final  bool? isBookmarked;

/// Create a copy of Ride
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RideCopyWith<_Ride> get copyWith => __$RideCopyWithImpl<_Ride>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RideToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Ride&&(identical(other.id, id) || other.id == id)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.departureStartTime, departureStartTime) || other.departureStartTime == departureStartTime)&&(identical(other.departureEndTime, departureEndTime) || other.departureEndTime == departureEndTime)&&(identical(other.maxMemberCount, maxMemberCount) || other.maxMemberCount == maxMemberCount)&&(identical(other.rideStartLocation, rideStartLocation) || other.rideStartLocation == rideStartLocation)&&(identical(other.rideEndLocation, rideEndLocation) || other.rideEndLocation == rideEndLocation)&&(identical(other.isBookmarked, isBookmarked) || other.isBookmarked == isBookmarked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdBy,comments,departureStartTime,departureEndTime,maxMemberCount,rideStartLocation,rideEndLocation,isBookmarked);

@override
String toString() {
  return 'Ride(id: $id, createdBy: $createdBy, comments: $comments, departureStartTime: $departureStartTime, departureEndTime: $departureEndTime, maxMemberCount: $maxMemberCount, rideStartLocation: $rideStartLocation, rideEndLocation: $rideEndLocation, isBookmarked: $isBookmarked)';
}


}

/// @nodoc
abstract mixin class _$RideCopyWith<$Res> implements $RideCopyWith<$Res> {
  factory _$RideCopyWith(_Ride value, $Res Function(_Ride) _then) = __$RideCopyWithImpl;
@override @useResult
$Res call({
 int id, String createdBy, String? comments, DateTime? departureStartTime, DateTime? departureEndTime, int? maxMemberCount, String? rideStartLocation, String? rideEndLocation, bool? isBookmarked
});




}
/// @nodoc
class __$RideCopyWithImpl<$Res>
    implements _$RideCopyWith<$Res> {
  __$RideCopyWithImpl(this._self, this._then);

  final _Ride _self;
  final $Res Function(_Ride) _then;

/// Create a copy of Ride
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdBy = null,Object? comments = freezed,Object? departureStartTime = freezed,Object? departureEndTime = freezed,Object? maxMemberCount = freezed,Object? rideStartLocation = freezed,Object? rideEndLocation = freezed,Object? isBookmarked = freezed,}) {
  return _then(_Ride(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String?,departureStartTime: freezed == departureStartTime ? _self.departureStartTime : departureStartTime // ignore: cast_nullable_to_non_nullable
as DateTime?,departureEndTime: freezed == departureEndTime ? _self.departureEndTime : departureEndTime // ignore: cast_nullable_to_non_nullable
as DateTime?,maxMemberCount: freezed == maxMemberCount ? _self.maxMemberCount : maxMemberCount // ignore: cast_nullable_to_non_nullable
as int?,rideStartLocation: freezed == rideStartLocation ? _self.rideStartLocation : rideStartLocation // ignore: cast_nullable_to_non_nullable
as String?,rideEndLocation: freezed == rideEndLocation ? _self.rideEndLocation : rideEndLocation // ignore: cast_nullable_to_non_nullable
as String?,isBookmarked: freezed == isBookmarked ? _self.isBookmarked : isBookmarked // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
