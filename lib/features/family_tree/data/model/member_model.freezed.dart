// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MemberModel {

@JsonKey() int? get id;@JsonKey() String? get fullName;@JsonKey() Gender? get gender;@JsonKey() String? get dateOfBirth;@JsonKey() String? get placeOfBirth;@JsonKey() bool? get isAlive;@JsonKey() String? get dateOfDeath;@JsonKey() MaritalStatus? get maritalStatus;@JsonKey() int? get generation;@JsonKey() int? get branchId;@JsonKey() String? get branchName;@JsonKey() int? get parentId;@JsonKey() int? get spouseId;@JsonKey() String? get notes;@JsonKey() String? get avatarUrl;
/// Create a copy of MemberModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberModelCopyWith<MemberModel> get copyWith => _$MemberModelCopyWithImpl<MemberModel>(this as MemberModel, _$identity);

  /// Serializes this MemberModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberModel&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.placeOfBirth, placeOfBirth) || other.placeOfBirth == placeOfBirth)&&(identical(other.isAlive, isAlive) || other.isAlive == isAlive)&&(identical(other.dateOfDeath, dateOfDeath) || other.dateOfDeath == dateOfDeath)&&(identical(other.maritalStatus, maritalStatus) || other.maritalStatus == maritalStatus)&&(identical(other.generation, generation) || other.generation == generation)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.branchName, branchName) || other.branchName == branchName)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.spouseId, spouseId) || other.spouseId == spouseId)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullName,gender,dateOfBirth,placeOfBirth,isAlive,dateOfDeath,maritalStatus,generation,branchId,branchName,parentId,spouseId,notes,avatarUrl);

@override
String toString() {
  return 'MemberModel(id: $id, fullName: $fullName, gender: $gender, dateOfBirth: $dateOfBirth, placeOfBirth: $placeOfBirth, isAlive: $isAlive, dateOfDeath: $dateOfDeath, maritalStatus: $maritalStatus, generation: $generation, branchId: $branchId, branchName: $branchName, parentId: $parentId, spouseId: $spouseId, notes: $notes, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $MemberModelCopyWith<$Res>  {
  factory $MemberModelCopyWith(MemberModel value, $Res Function(MemberModel) _then) = _$MemberModelCopyWithImpl;
@useResult
$Res call({
@JsonKey() int? id,@JsonKey() String? fullName,@JsonKey() Gender? gender,@JsonKey() String? dateOfBirth,@JsonKey() String? placeOfBirth,@JsonKey() bool? isAlive,@JsonKey() String? dateOfDeath,@JsonKey() MaritalStatus? maritalStatus,@JsonKey() int? generation,@JsonKey() int? branchId,@JsonKey() String? branchName,@JsonKey() int? parentId,@JsonKey() int? spouseId,@JsonKey() String? notes,@JsonKey() String? avatarUrl
});




}
/// @nodoc
class _$MemberModelCopyWithImpl<$Res>
    implements $MemberModelCopyWith<$Res> {
  _$MemberModelCopyWithImpl(this._self, this._then);

  final MemberModel _self;
  final $Res Function(MemberModel) _then;

/// Create a copy of MemberModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? fullName = freezed,Object? gender = freezed,Object? dateOfBirth = freezed,Object? placeOfBirth = freezed,Object? isAlive = freezed,Object? dateOfDeath = freezed,Object? maritalStatus = freezed,Object? generation = freezed,Object? branchId = freezed,Object? branchName = freezed,Object? parentId = freezed,Object? spouseId = freezed,Object? notes = freezed,Object? avatarUrl = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String?,placeOfBirth: freezed == placeOfBirth ? _self.placeOfBirth : placeOfBirth // ignore: cast_nullable_to_non_nullable
as String?,isAlive: freezed == isAlive ? _self.isAlive : isAlive // ignore: cast_nullable_to_non_nullable
as bool?,dateOfDeath: freezed == dateOfDeath ? _self.dateOfDeath : dateOfDeath // ignore: cast_nullable_to_non_nullable
as String?,maritalStatus: freezed == maritalStatus ? _self.maritalStatus : maritalStatus // ignore: cast_nullable_to_non_nullable
as MaritalStatus?,generation: freezed == generation ? _self.generation : generation // ignore: cast_nullable_to_non_nullable
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


/// Adds pattern-matching-related methods to [MemberModel].
extension MemberModelPatterns on MemberModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemberModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemberModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemberModel value)  $default,){
final _that = this;
switch (_that) {
case _MemberModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemberModel value)?  $default,){
final _that = this;
switch (_that) {
case _MemberModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey()  int? id, @JsonKey()  String? fullName, @JsonKey()  Gender? gender, @JsonKey()  String? dateOfBirth, @JsonKey()  String? placeOfBirth, @JsonKey()  bool? isAlive, @JsonKey()  String? dateOfDeath, @JsonKey()  MaritalStatus? maritalStatus, @JsonKey()  int? generation, @JsonKey()  int? branchId, @JsonKey()  String? branchName, @JsonKey()  int? parentId, @JsonKey()  int? spouseId, @JsonKey()  String? notes, @JsonKey()  String? avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemberModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey()  int? id, @JsonKey()  String? fullName, @JsonKey()  Gender? gender, @JsonKey()  String? dateOfBirth, @JsonKey()  String? placeOfBirth, @JsonKey()  bool? isAlive, @JsonKey()  String? dateOfDeath, @JsonKey()  MaritalStatus? maritalStatus, @JsonKey()  int? generation, @JsonKey()  int? branchId, @JsonKey()  String? branchName, @JsonKey()  int? parentId, @JsonKey()  int? spouseId, @JsonKey()  String? notes, @JsonKey()  String? avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _MemberModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey()  int? id, @JsonKey()  String? fullName, @JsonKey()  Gender? gender, @JsonKey()  String? dateOfBirth, @JsonKey()  String? placeOfBirth, @JsonKey()  bool? isAlive, @JsonKey()  String? dateOfDeath, @JsonKey()  MaritalStatus? maritalStatus, @JsonKey()  int? generation, @JsonKey()  int? branchId, @JsonKey()  String? branchName, @JsonKey()  int? parentId, @JsonKey()  int? spouseId, @JsonKey()  String? notes, @JsonKey()  String? avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _MemberModel() when $default != null:
return $default(_that.id,_that.fullName,_that.gender,_that.dateOfBirth,_that.placeOfBirth,_that.isAlive,_that.dateOfDeath,_that.maritalStatus,_that.generation,_that.branchId,_that.branchName,_that.parentId,_that.spouseId,_that.notes,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MemberModel extends MemberModel {
  const _MemberModel({@JsonKey() this.id, @JsonKey() this.fullName, @JsonKey() this.gender, @JsonKey() this.dateOfBirth, @JsonKey() this.placeOfBirth, @JsonKey() this.isAlive, @JsonKey() this.dateOfDeath, @JsonKey() this.maritalStatus, @JsonKey() this.generation, @JsonKey() this.branchId, @JsonKey() this.branchName, @JsonKey() this.parentId, @JsonKey() this.spouseId, @JsonKey() this.notes, @JsonKey() this.avatarUrl}): super._();
  factory _MemberModel.fromJson(Map<String, dynamic> json) => _$MemberModelFromJson(json);

@override@JsonKey() final  int? id;
@override@JsonKey() final  String? fullName;
@override@JsonKey() final  Gender? gender;
@override@JsonKey() final  String? dateOfBirth;
@override@JsonKey() final  String? placeOfBirth;
@override@JsonKey() final  bool? isAlive;
@override@JsonKey() final  String? dateOfDeath;
@override@JsonKey() final  MaritalStatus? maritalStatus;
@override@JsonKey() final  int? generation;
@override@JsonKey() final  int? branchId;
@override@JsonKey() final  String? branchName;
@override@JsonKey() final  int? parentId;
@override@JsonKey() final  int? spouseId;
@override@JsonKey() final  String? notes;
@override@JsonKey() final  String? avatarUrl;

/// Create a copy of MemberModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberModelCopyWith<_MemberModel> get copyWith => __$MemberModelCopyWithImpl<_MemberModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemberModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberModel&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.placeOfBirth, placeOfBirth) || other.placeOfBirth == placeOfBirth)&&(identical(other.isAlive, isAlive) || other.isAlive == isAlive)&&(identical(other.dateOfDeath, dateOfDeath) || other.dateOfDeath == dateOfDeath)&&(identical(other.maritalStatus, maritalStatus) || other.maritalStatus == maritalStatus)&&(identical(other.generation, generation) || other.generation == generation)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.branchName, branchName) || other.branchName == branchName)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.spouseId, spouseId) || other.spouseId == spouseId)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullName,gender,dateOfBirth,placeOfBirth,isAlive,dateOfDeath,maritalStatus,generation,branchId,branchName,parentId,spouseId,notes,avatarUrl);

@override
String toString() {
  return 'MemberModel(id: $id, fullName: $fullName, gender: $gender, dateOfBirth: $dateOfBirth, placeOfBirth: $placeOfBirth, isAlive: $isAlive, dateOfDeath: $dateOfDeath, maritalStatus: $maritalStatus, generation: $generation, branchId: $branchId, branchName: $branchName, parentId: $parentId, spouseId: $spouseId, notes: $notes, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$MemberModelCopyWith<$Res> implements $MemberModelCopyWith<$Res> {
  factory _$MemberModelCopyWith(_MemberModel value, $Res Function(_MemberModel) _then) = __$MemberModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey() int? id,@JsonKey() String? fullName,@JsonKey() Gender? gender,@JsonKey() String? dateOfBirth,@JsonKey() String? placeOfBirth,@JsonKey() bool? isAlive,@JsonKey() String? dateOfDeath,@JsonKey() MaritalStatus? maritalStatus,@JsonKey() int? generation,@JsonKey() int? branchId,@JsonKey() String? branchName,@JsonKey() int? parentId,@JsonKey() int? spouseId,@JsonKey() String? notes,@JsonKey() String? avatarUrl
});




}
/// @nodoc
class __$MemberModelCopyWithImpl<$Res>
    implements _$MemberModelCopyWith<$Res> {
  __$MemberModelCopyWithImpl(this._self, this._then);

  final _MemberModel _self;
  final $Res Function(_MemberModel) _then;

/// Create a copy of MemberModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? fullName = freezed,Object? gender = freezed,Object? dateOfBirth = freezed,Object? placeOfBirth = freezed,Object? isAlive = freezed,Object? dateOfDeath = freezed,Object? maritalStatus = freezed,Object? generation = freezed,Object? branchId = freezed,Object? branchName = freezed,Object? parentId = freezed,Object? spouseId = freezed,Object? notes = freezed,Object? avatarUrl = freezed,}) {
  return _then(_MemberModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String?,placeOfBirth: freezed == placeOfBirth ? _self.placeOfBirth : placeOfBirth // ignore: cast_nullable_to_non_nullable
as String?,isAlive: freezed == isAlive ? _self.isAlive : isAlive // ignore: cast_nullable_to_non_nullable
as bool?,dateOfDeath: freezed == dateOfDeath ? _self.dateOfDeath : dateOfDeath // ignore: cast_nullable_to_non_nullable
as String?,maritalStatus: freezed == maritalStatus ? _self.maritalStatus : maritalStatus // ignore: cast_nullable_to_non_nullable
as MaritalStatus?,generation: freezed == generation ? _self.generation : generation // ignore: cast_nullable_to_non_nullable
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
