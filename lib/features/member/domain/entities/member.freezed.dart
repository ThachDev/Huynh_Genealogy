// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MemberEntity {

 int get id; String get fullName; Gender get gender; String? get dateOfBirth; String? get placeOfBirth; bool get isAlive; String? get dateOfDeath; MaritalStatus get maritalStatus; int? get generation; int? get branchId; String? get branchName; int? get parentId; int? get spouseId; String? get notes; String? get avatarUrl;
/// Create a copy of MemberEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberEntityCopyWith<MemberEntity> get copyWith => _$MemberEntityCopyWithImpl<MemberEntity>(this as MemberEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.placeOfBirth, placeOfBirth) || other.placeOfBirth == placeOfBirth)&&(identical(other.isAlive, isAlive) || other.isAlive == isAlive)&&(identical(other.dateOfDeath, dateOfDeath) || other.dateOfDeath == dateOfDeath)&&(identical(other.maritalStatus, maritalStatus) || other.maritalStatus == maritalStatus)&&(identical(other.generation, generation) || other.generation == generation)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.branchName, branchName) || other.branchName == branchName)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.spouseId, spouseId) || other.spouseId == spouseId)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,fullName,gender,dateOfBirth,placeOfBirth,isAlive,dateOfDeath,maritalStatus,generation,branchId,branchName,parentId,spouseId,notes,avatarUrl);

@override
String toString() {
  return 'MemberEntity(id: $id, fullName: $fullName, gender: $gender, dateOfBirth: $dateOfBirth, placeOfBirth: $placeOfBirth, isAlive: $isAlive, dateOfDeath: $dateOfDeath, maritalStatus: $maritalStatus, generation: $generation, branchId: $branchId, branchName: $branchName, parentId: $parentId, spouseId: $spouseId, notes: $notes, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $MemberEntityCopyWith<$Res>  {
  factory $MemberEntityCopyWith(MemberEntity value, $Res Function(MemberEntity) _then) = _$MemberEntityCopyWithImpl;
@useResult
$Res call({
 int id, String fullName, Gender gender, String? dateOfBirth, String? placeOfBirth, bool isAlive, String? dateOfDeath, MaritalStatus maritalStatus, int? generation, int? branchId, String? branchName, int? parentId, int? spouseId, String? notes, String? avatarUrl
});




}
/// @nodoc
class _$MemberEntityCopyWithImpl<$Res>
    implements $MemberEntityCopyWith<$Res> {
  _$MemberEntityCopyWithImpl(this._self, this._then);

  final MemberEntity _self;
  final $Res Function(MemberEntity) _then;

/// Create a copy of MemberEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = null,Object? gender = null,Object? dateOfBirth = freezed,Object? placeOfBirth = freezed,Object? isAlive = null,Object? dateOfDeath = freezed,Object? maritalStatus = null,Object? generation = freezed,Object? branchId = freezed,Object? branchName = freezed,Object? parentId = freezed,Object? spouseId = freezed,Object? notes = freezed,Object? avatarUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String?,placeOfBirth: freezed == placeOfBirth ? _self.placeOfBirth : placeOfBirth // ignore: cast_nullable_to_non_nullable
as String?,isAlive: null == isAlive ? _self.isAlive : isAlive // ignore: cast_nullable_to_non_nullable
as bool,dateOfDeath: freezed == dateOfDeath ? _self.dateOfDeath : dateOfDeath // ignore: cast_nullable_to_non_nullable
as String?,maritalStatus: null == maritalStatus ? _self.maritalStatus : maritalStatus // ignore: cast_nullable_to_non_nullable
as MaritalStatus,generation: freezed == generation ? _self.generation : generation // ignore: cast_nullable_to_non_nullable
as int?,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as int?,branchName: freezed == branchName ? _self.branchName : branchName // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as int?,spouseId: freezed == spouseId ? _self.spouseId : spouseId // ignore: cast_nullable_to_non_nullable
as int?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MemberEntity].
extension MemberEntityPatterns on MemberEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemberEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemberEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemberEntity value)  $default,){
final _that = this;
switch (_that) {
case _MemberEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemberEntity value)?  $default,){
final _that = this;
switch (_that) {
case _MemberEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String fullName,  Gender gender,  String? dateOfBirth,  String? placeOfBirth,  bool isAlive,  String? dateOfDeath,  MaritalStatus maritalStatus,  int? generation,  int? branchId,  String? branchName,  int? parentId,  int? spouseId,  String? notes,  String? avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemberEntity() when $default != null:
return $default(_that.id,_that.fullName,_that.gender,_that.dateOfBirth,_that.placeOfBirth,_that.isAlive,_that.dateOfDeath,_that.maritalStatus,_that.generation,_that.branchId,_that.branchName,_that.parentId,_that.spouseId,_that.notes,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String fullName,  Gender gender,  String? dateOfBirth,  String? placeOfBirth,  bool isAlive,  String? dateOfDeath,  MaritalStatus maritalStatus,  int? generation,  int? branchId,  String? branchName,  int? parentId,  int? spouseId,  String? notes,  String? avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _MemberEntity():
return $default(_that.id,_that.fullName,_that.gender,_that.dateOfBirth,_that.placeOfBirth,_that.isAlive,_that.dateOfDeath,_that.maritalStatus,_that.generation,_that.branchId,_that.branchName,_that.parentId,_that.spouseId,_that.notes,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String fullName,  Gender gender,  String? dateOfBirth,  String? placeOfBirth,  bool isAlive,  String? dateOfDeath,  MaritalStatus maritalStatus,  int? generation,  int? branchId,  String? branchName,  int? parentId,  int? spouseId,  String? notes,  String? avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _MemberEntity() when $default != null:
return $default(_that.id,_that.fullName,_that.gender,_that.dateOfBirth,_that.placeOfBirth,_that.isAlive,_that.dateOfDeath,_that.maritalStatus,_that.generation,_that.branchId,_that.branchName,_that.parentId,_that.spouseId,_that.notes,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc


class _MemberEntity implements MemberEntity {
  const _MemberEntity({this.id = 0, this.fullName = '', this.gender = Gender.unknown, this.dateOfBirth, this.placeOfBirth, this.isAlive = true, this.dateOfDeath, this.maritalStatus = MaritalStatus.unknown, this.generation, this.branchId, this.branchName, this.parentId, this.spouseId, this.notes, this.avatarUrl});
  

@override@JsonKey() final  int id;
@override@JsonKey() final  String fullName;
@override@JsonKey() final  Gender gender;
@override final  String? dateOfBirth;
@override final  String? placeOfBirth;
@override@JsonKey() final  bool isAlive;
@override final  String? dateOfDeath;
@override@JsonKey() final  MaritalStatus maritalStatus;
@override final  int? generation;
@override final  int? branchId;
@override final  String? branchName;
@override final  int? parentId;
@override final  int? spouseId;
@override final  String? notes;
@override final  String? avatarUrl;

/// Create a copy of MemberEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberEntityCopyWith<_MemberEntity> get copyWith => __$MemberEntityCopyWithImpl<_MemberEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.placeOfBirth, placeOfBirth) || other.placeOfBirth == placeOfBirth)&&(identical(other.isAlive, isAlive) || other.isAlive == isAlive)&&(identical(other.dateOfDeath, dateOfDeath) || other.dateOfDeath == dateOfDeath)&&(identical(other.maritalStatus, maritalStatus) || other.maritalStatus == maritalStatus)&&(identical(other.generation, generation) || other.generation == generation)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.branchName, branchName) || other.branchName == branchName)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.spouseId, spouseId) || other.spouseId == spouseId)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,fullName,gender,dateOfBirth,placeOfBirth,isAlive,dateOfDeath,maritalStatus,generation,branchId,branchName,parentId,spouseId,notes,avatarUrl);

@override
String toString() {
  return 'MemberEntity(id: $id, fullName: $fullName, gender: $gender, dateOfBirth: $dateOfBirth, placeOfBirth: $placeOfBirth, isAlive: $isAlive, dateOfDeath: $dateOfDeath, maritalStatus: $maritalStatus, generation: $generation, branchId: $branchId, branchName: $branchName, parentId: $parentId, spouseId: $spouseId, notes: $notes, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$MemberEntityCopyWith<$Res> implements $MemberEntityCopyWith<$Res> {
  factory _$MemberEntityCopyWith(_MemberEntity value, $Res Function(_MemberEntity) _then) = __$MemberEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String fullName, Gender gender, String? dateOfBirth, String? placeOfBirth, bool isAlive, String? dateOfDeath, MaritalStatus maritalStatus, int? generation, int? branchId, String? branchName, int? parentId, int? spouseId, String? notes, String? avatarUrl
});




}
/// @nodoc
class __$MemberEntityCopyWithImpl<$Res>
    implements _$MemberEntityCopyWith<$Res> {
  __$MemberEntityCopyWithImpl(this._self, this._then);

  final _MemberEntity _self;
  final $Res Function(_MemberEntity) _then;

/// Create a copy of MemberEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? gender = null,Object? dateOfBirth = freezed,Object? placeOfBirth = freezed,Object? isAlive = null,Object? dateOfDeath = freezed,Object? maritalStatus = null,Object? generation = freezed,Object? branchId = freezed,Object? branchName = freezed,Object? parentId = freezed,Object? spouseId = freezed,Object? notes = freezed,Object? avatarUrl = freezed,}) {
  return _then(_MemberEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String?,placeOfBirth: freezed == placeOfBirth ? _self.placeOfBirth : placeOfBirth // ignore: cast_nullable_to_non_nullable
as String?,isAlive: null == isAlive ? _self.isAlive : isAlive // ignore: cast_nullable_to_non_nullable
as bool,dateOfDeath: freezed == dateOfDeath ? _self.dateOfDeath : dateOfDeath // ignore: cast_nullable_to_non_nullable
as String?,maritalStatus: null == maritalStatus ? _self.maritalStatus : maritalStatus // ignore: cast_nullable_to_non_nullable
as MaritalStatus,generation: freezed == generation ? _self.generation : generation // ignore: cast_nullable_to_non_nullable
as int?,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as int?,branchName: freezed == branchName ? _self.branchName : branchName // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as int?,spouseId: freezed == spouseId ? _self.spouseId : spouseId // ignore: cast_nullable_to_non_nullable
as int?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
