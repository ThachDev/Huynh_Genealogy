// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FamilyEntity _$FamilyEntityFromJson(Map<String, dynamic> json) {
  return _FamilyEntity.fromJson(json);
}

/// @nodoc
mixin _$FamilyEntity {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get inviteCode => throw _privateConstructorUsedError;
  int get creatorId => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get origin => throw _privateConstructorUsedError;
  String? get logoUrl => throw _privateConstructorUsedError;

  /// Serializes this FamilyEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FamilyEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FamilyEntityCopyWith<FamilyEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FamilyEntityCopyWith<$Res> {
  factory $FamilyEntityCopyWith(
          FamilyEntity value, $Res Function(FamilyEntity) then) =
      _$FamilyEntityCopyWithImpl<$Res, FamilyEntity>;
  @useResult
  $Res call(
      {int id,
      String name,
      String inviteCode,
      int creatorId,
      String? description,
      String? origin,
      String? logoUrl});
}

/// @nodoc
class _$FamilyEntityCopyWithImpl<$Res, $Val extends FamilyEntity>
    implements $FamilyEntityCopyWith<$Res> {
  _$FamilyEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FamilyEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? inviteCode = null,
    Object? creatorId = null,
    Object? description = freezed,
    Object? origin = freezed,
    Object? logoUrl = freezed,
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
      inviteCode: null == inviteCode
          ? _value.inviteCode
          : inviteCode // ignore: cast_nullable_to_non_nullable
              as String,
      creatorId: null == creatorId
          ? _value.creatorId
          : creatorId // ignore: cast_nullable_to_non_nullable
              as int,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      origin: freezed == origin
          ? _value.origin
          : origin // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FamilyEntityImplCopyWith<$Res>
    implements $FamilyEntityCopyWith<$Res> {
  factory _$$FamilyEntityImplCopyWith(
          _$FamilyEntityImpl value, $Res Function(_$FamilyEntityImpl) then) =
      __$$FamilyEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String inviteCode,
      int creatorId,
      String? description,
      String? origin,
      String? logoUrl});
}

/// @nodoc
class __$$FamilyEntityImplCopyWithImpl<$Res>
    extends _$FamilyEntityCopyWithImpl<$Res, _$FamilyEntityImpl>
    implements _$$FamilyEntityImplCopyWith<$Res> {
  __$$FamilyEntityImplCopyWithImpl(
      _$FamilyEntityImpl _value, $Res Function(_$FamilyEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of FamilyEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? inviteCode = null,
    Object? creatorId = null,
    Object? description = freezed,
    Object? origin = freezed,
    Object? logoUrl = freezed,
  }) {
    return _then(_$FamilyEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      inviteCode: null == inviteCode
          ? _value.inviteCode
          : inviteCode // ignore: cast_nullable_to_non_nullable
              as String,
      creatorId: null == creatorId
          ? _value.creatorId
          : creatorId // ignore: cast_nullable_to_non_nullable
              as int,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      origin: freezed == origin
          ? _value.origin
          : origin // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FamilyEntityImpl implements _FamilyEntity {
  const _$FamilyEntityImpl(
      {required this.id,
      required this.name,
      required this.inviteCode,
      required this.creatorId,
      this.description,
      this.origin,
      this.logoUrl});

  factory _$FamilyEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$FamilyEntityImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String inviteCode;
  @override
  final int creatorId;
  @override
  final String? description;
  @override
  final String? origin;
  @override
  final String? logoUrl;

  @override
  String toString() {
    return 'FamilyEntity(id: $id, name: $name, inviteCode: $inviteCode, creatorId: $creatorId, description: $description, origin: $origin, logoUrl: $logoUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FamilyEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.inviteCode, inviteCode) ||
                other.inviteCode == inviteCode) &&
            (identical(other.creatorId, creatorId) ||
                other.creatorId == creatorId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.origin, origin) || other.origin == origin) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, inviteCode, creatorId,
      description, origin, logoUrl);

  /// Create a copy of FamilyEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FamilyEntityImplCopyWith<_$FamilyEntityImpl> get copyWith =>
      __$$FamilyEntityImplCopyWithImpl<_$FamilyEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FamilyEntityImplToJson(
      this,
    );
  }
}

abstract class _FamilyEntity implements FamilyEntity {
  const factory _FamilyEntity(
      {required final int id,
      required final String name,
      required final String inviteCode,
      required final int creatorId,
      final String? description,
      final String? origin,
      final String? logoUrl}) = _$FamilyEntityImpl;

  factory _FamilyEntity.fromJson(Map<String, dynamic> json) =
      _$FamilyEntityImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get inviteCode;
  @override
  int get creatorId;
  @override
  String? get description;
  @override
  String? get origin;
  @override
  String? get logoUrl;

  /// Create a copy of FamilyEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FamilyEntityImplCopyWith<_$FamilyEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
