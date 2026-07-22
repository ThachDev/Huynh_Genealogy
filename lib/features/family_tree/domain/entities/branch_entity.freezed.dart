// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'branch_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BranchEntity _$BranchEntityFromJson(Map<String, dynamic> json) {
  return _BranchEntity.fromJson(json);
}

/// @nodoc
mixin _$BranchEntity {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get founderName => throw _privateConstructorUsedError;
  int? get foundingYear => throw _privateConstructorUsedError;
  String? get region => throw _privateConstructorUsedError;
  int? get familyId => throw _privateConstructorUsedError;

  /// Serializes this BranchEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BranchEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BranchEntityCopyWith<BranchEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BranchEntityCopyWith<$Res> {
  factory $BranchEntityCopyWith(
          BranchEntity value, $Res Function(BranchEntity) then) =
      _$BranchEntityCopyWithImpl<$Res, BranchEntity>;
  @useResult
  $Res call(
      {int id,
      String name,
      String? description,
      String? founderName,
      int? foundingYear,
      String? region,
      int? familyId});
}

/// @nodoc
class _$BranchEntityCopyWithImpl<$Res, $Val extends BranchEntity>
    implements $BranchEntityCopyWith<$Res> {
  _$BranchEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BranchEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? founderName = freezed,
    Object? foundingYear = freezed,
    Object? region = freezed,
    Object? familyId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      founderName: freezed == founderName
          ? _value.founderName
          : founderName // ignore: cast_nullable_to_non_nullable
              as String?,
      foundingYear: freezed == foundingYear
          ? _value.foundingYear
          : foundingYear // ignore: cast_nullable_to_non_nullable
              as int?,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      familyId: freezed == familyId
          ? _value.familyId
          : familyId // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BranchEntityImplCopyWith<$Res>
    implements $BranchEntityCopyWith<$Res> {
  factory _$$BranchEntityImplCopyWith(
          _$BranchEntityImpl value, $Res Function(_$BranchEntityImpl) then) =
      __$$BranchEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String? description,
      String? founderName,
      int? foundingYear,
      String? region,
      int? familyId});
}

/// @nodoc
class __$$BranchEntityImplCopyWithImpl<$Res>
    extends _$BranchEntityCopyWithImpl<$Res, _$BranchEntityImpl>
    implements _$$BranchEntityImplCopyWith<$Res> {
  __$$BranchEntityImplCopyWithImpl(
      _$BranchEntityImpl _value, $Res Function(_$BranchEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of BranchEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? founderName = freezed,
    Object? foundingYear = freezed,
    Object? region = freezed,
    Object? familyId = freezed,
  }) {
    return _then(_$BranchEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      founderName: freezed == founderName
          ? _value.founderName
          : founderName // ignore: cast_nullable_to_non_nullable
              as String?,
      foundingYear: freezed == foundingYear
          ? _value.foundingYear
          : foundingYear // ignore: cast_nullable_to_non_nullable
              as int?,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      familyId: freezed == familyId
          ? _value.familyId
          : familyId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BranchEntityImpl implements _BranchEntity {
  const _$BranchEntityImpl(
      {required this.id,
      required this.name,
      this.description,
      this.founderName,
      this.foundingYear,
      this.region,
      this.familyId});

  factory _$BranchEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$BranchEntityImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? founderName;
  @override
  final int? foundingYear;
  @override
  final String? region;
  @override
  final int? familyId;

  @override
  String toString() {
    return 'BranchEntity(id: $id, name: $name, description: $description, founderName: $founderName, foundingYear: $foundingYear, region: $region, familyId: $familyId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BranchEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.founderName, founderName) ||
                other.founderName == founderName) &&
            (identical(other.foundingYear, foundingYear) ||
                other.foundingYear == foundingYear) &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.familyId, familyId) ||
                other.familyId == familyId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description,
      founderName, foundingYear, region, familyId);

  /// Create a copy of BranchEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BranchEntityImplCopyWith<_$BranchEntityImpl> get copyWith =>
      __$$BranchEntityImplCopyWithImpl<_$BranchEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BranchEntityImplToJson(
      this,
    );
  }
}

abstract class _BranchEntity implements BranchEntity {
  const factory _BranchEntity(
      {required final int id,
      required final String name,
      final String? description,
      final String? founderName,
      final int? foundingYear,
      final String? region,
      final int? familyId}) = _$BranchEntityImpl;

  factory _BranchEntity.fromJson(Map<String, dynamic> json) =
      _$BranchEntityImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get founderName;
  @override
  int? get foundingYear;
  @override
  String? get region;
  @override
  int? get familyId;

  /// Create a copy of BranchEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BranchEntityImplCopyWith<_$BranchEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
