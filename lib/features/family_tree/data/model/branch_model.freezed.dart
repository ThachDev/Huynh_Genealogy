// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'branch_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BranchModel {

@JsonKey() int? get id;@JsonKey() String? get name;@JsonKey() String? get description;@JsonKey() String? get founderName;@JsonKey() int? get foundingYear;@JsonKey() String? get region;
/// Create a copy of BranchModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BranchModelCopyWith<BranchModel> get copyWith => _$BranchModelCopyWithImpl<BranchModel>(this as BranchModel, _$identity);

  /// Serializes this BranchModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BranchModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.founderName, founderName) || other.founderName == founderName)&&(identical(other.foundingYear, foundingYear) || other.foundingYear == foundingYear)&&(identical(other.region, region) || other.region == region));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,founderName,foundingYear,region);

@override
String toString() {
  return 'BranchModel(id: $id, name: $name, description: $description, founderName: $founderName, foundingYear: $foundingYear, region: $region)';
}


}

/// @nodoc
abstract mixin class $BranchModelCopyWith<$Res>  {
  factory $BranchModelCopyWith(BranchModel value, $Res Function(BranchModel) _then) = _$BranchModelCopyWithImpl;
@useResult
$Res call({
@JsonKey() int? id,@JsonKey() String? name,@JsonKey() String? description,@JsonKey() String? founderName,@JsonKey() int? foundingYear,@JsonKey() String? region
});




}
/// @nodoc
class _$BranchModelCopyWithImpl<$Res>
    implements $BranchModelCopyWith<$Res> {
  _$BranchModelCopyWithImpl(this._self, this._then);

  final BranchModel _self;
  final $Res Function(BranchModel) _then;

/// Create a copy of BranchModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? description = freezed,Object? founderName = freezed,Object? foundingYear = freezed,Object? region = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,founderName: freezed == founderName ? _self.founderName : founderName // ignore: cast_nullable_to_non_nullable
as String?,foundingYear: freezed == foundingYear ? _self.foundingYear : foundingYear // ignore: cast_nullable_to_non_nullable
as int?,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BranchModel].
extension BranchModelPatterns on BranchModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BranchModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BranchModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BranchModel value)  $default,){
final _that = this;
switch (_that) {
case _BranchModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BranchModel value)?  $default,){
final _that = this;
switch (_that) {
case _BranchModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey()  int? id, @JsonKey()  String? name, @JsonKey()  String? description, @JsonKey()  String? founderName, @JsonKey()  int? foundingYear, @JsonKey()  String? region)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BranchModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey()  int? id, @JsonKey()  String? name, @JsonKey()  String? description, @JsonKey()  String? founderName, @JsonKey()  int? foundingYear, @JsonKey()  String? region)  $default,) {final _that = this;
switch (_that) {
case _BranchModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey()  int? id, @JsonKey()  String? name, @JsonKey()  String? description, @JsonKey()  String? founderName, @JsonKey()  int? foundingYear, @JsonKey()  String? region)?  $default,) {final _that = this;
switch (_that) {
case _BranchModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.founderName,_that.foundingYear,_that.region);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BranchModel extends BranchModel {
  const _BranchModel({@JsonKey() this.id, @JsonKey() this.name, @JsonKey() this.description, @JsonKey() this.founderName, @JsonKey() this.foundingYear, @JsonKey() this.region}): super._();
  factory _BranchModel.fromJson(Map<String, dynamic> json) => _$BranchModelFromJson(json);

@override@JsonKey() final  int? id;
@override@JsonKey() final  String? name;
@override@JsonKey() final  String? description;
@override@JsonKey() final  String? founderName;
@override@JsonKey() final  int? foundingYear;
@override@JsonKey() final  String? region;

/// Create a copy of BranchModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BranchModelCopyWith<_BranchModel> get copyWith => __$BranchModelCopyWithImpl<_BranchModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BranchModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BranchModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.founderName, founderName) || other.founderName == founderName)&&(identical(other.foundingYear, foundingYear) || other.foundingYear == foundingYear)&&(identical(other.region, region) || other.region == region));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,founderName,foundingYear,region);

@override
String toString() {
  return 'BranchModel(id: $id, name: $name, description: $description, founderName: $founderName, foundingYear: $foundingYear, region: $region)';
}


}

/// @nodoc
abstract mixin class _$BranchModelCopyWith<$Res> implements $BranchModelCopyWith<$Res> {
  factory _$BranchModelCopyWith(_BranchModel value, $Res Function(_BranchModel) _then) = __$BranchModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey() int? id,@JsonKey() String? name,@JsonKey() String? description,@JsonKey() String? founderName,@JsonKey() int? foundingYear,@JsonKey() String? region
});




}
/// @nodoc
class __$BranchModelCopyWithImpl<$Res>
    implements _$BranchModelCopyWith<$Res> {
  __$BranchModelCopyWithImpl(this._self, this._then);

  final _BranchModel _self;
  final $Res Function(_BranchModel) _then;

/// Create a copy of BranchModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? description = freezed,Object? founderName = freezed,Object? foundingYear = freezed,Object? region = freezed,}) {
  return _then(_BranchModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,founderName: freezed == founderName ? _self.founderName : founderName // ignore: cast_nullable_to_non_nullable
as String?,foundingYear: freezed == foundingYear ? _self.foundingYear : foundingYear // ignore: cast_nullable_to_non_nullable
as int?,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
