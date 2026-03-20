// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'branch.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BranchEntity {

 int get id; String get name; String? get description; String? get founderName; int? get foundingYear; String? get region;
/// Create a copy of BranchEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BranchEntityCopyWith<BranchEntity> get copyWith => _$BranchEntityCopyWithImpl<BranchEntity>(this as BranchEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BranchEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.founderName, founderName) || other.founderName == founderName)&&(identical(other.foundingYear, foundingYear) || other.foundingYear == foundingYear)&&(identical(other.region, region) || other.region == region));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,founderName,foundingYear,region);

@override
String toString() {
  return 'BranchEntity(id: $id, name: $name, description: $description, founderName: $founderName, foundingYear: $foundingYear, region: $region)';
}


}

/// @nodoc
abstract mixin class $BranchEntityCopyWith<$Res>  {
  factory $BranchEntityCopyWith(BranchEntity value, $Res Function(BranchEntity) _then) = _$BranchEntityCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? description, String? founderName, int? foundingYear, String? region
});




}
/// @nodoc
class _$BranchEntityCopyWithImpl<$Res>
    implements $BranchEntityCopyWith<$Res> {
  _$BranchEntityCopyWithImpl(this._self, this._then);

  final BranchEntity _self;
  final $Res Function(BranchEntity) _then;

/// Create a copy of BranchEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? founderName = freezed,Object? foundingYear = freezed,Object? region = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,founderName: freezed == founderName ? _self.founderName : founderName // ignore: cast_nullable_to_non_nullable
as String?,foundingYear: freezed == foundingYear ? _self.foundingYear : foundingYear // ignore: cast_nullable_to_non_nullable
as int?,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BranchEntity].
extension BranchEntityPatterns on BranchEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BranchEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BranchEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BranchEntity value)  $default,){
final _that = this;
switch (_that) {
case _BranchEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BranchEntity value)?  $default,){
final _that = this;
switch (_that) {
case _BranchEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? description,  String? founderName,  int? foundingYear,  String? region)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BranchEntity() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.founderName,_that.foundingYear,_that.region);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? description,  String? founderName,  int? foundingYear,  String? region)  $default,) {final _that = this;
switch (_that) {
case _BranchEntity():
return $default(_that.id,_that.name,_that.description,_that.founderName,_that.foundingYear,_that.region);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? description,  String? founderName,  int? foundingYear,  String? region)?  $default,) {final _that = this;
switch (_that) {
case _BranchEntity() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.founderName,_that.foundingYear,_that.region);case _:
  return null;

}
}

}

/// @nodoc


class _BranchEntity implements BranchEntity {
  const _BranchEntity({this.id = 0, this.name = '', this.description, this.founderName, this.foundingYear, this.region});
  

@override@JsonKey() final  int id;
@override@JsonKey() final  String name;
@override final  String? description;
@override final  String? founderName;
@override final  int? foundingYear;
@override final  String? region;

/// Create a copy of BranchEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BranchEntityCopyWith<_BranchEntity> get copyWith => __$BranchEntityCopyWithImpl<_BranchEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BranchEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.founderName, founderName) || other.founderName == founderName)&&(identical(other.foundingYear, foundingYear) || other.foundingYear == foundingYear)&&(identical(other.region, region) || other.region == region));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,founderName,foundingYear,region);

@override
String toString() {
  return 'BranchEntity(id: $id, name: $name, description: $description, founderName: $founderName, foundingYear: $foundingYear, region: $region)';
}


}

/// @nodoc
abstract mixin class _$BranchEntityCopyWith<$Res> implements $BranchEntityCopyWith<$Res> {
  factory _$BranchEntityCopyWith(_BranchEntity value, $Res Function(_BranchEntity) _then) = __$BranchEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? description, String? founderName, int? foundingYear, String? region
});




}
/// @nodoc
class __$BranchEntityCopyWithImpl<$Res>
    implements _$BranchEntityCopyWith<$Res> {
  __$BranchEntityCopyWithImpl(this._self, this._then);

  final _BranchEntity _self;
  final $Res Function(_BranchEntity) _then;

/// Create a copy of BranchEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? founderName = freezed,Object? foundingYear = freezed,Object? region = freezed,}) {
  return _then(_BranchEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,founderName: freezed == founderName ? _self.founderName : founderName // ignore: cast_nullable_to_non_nullable
as String?,foundingYear: freezed == foundingYear ? _self.foundingYear : foundingYear // ignore: cast_nullable_to_non_nullable
as int?,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
