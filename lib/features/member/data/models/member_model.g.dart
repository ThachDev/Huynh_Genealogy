// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MemberModel _$MemberModelFromJson(Map<String, dynamic> json) => _MemberModel(
  id: (json['id'] as num?)?.toInt(),
  fullName: json['fullName'] as String?,
  gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
  dateOfBirth: json['dateOfBirth'] as String?,
  placeOfBirth: json['placeOfBirth'] as String?,
  isAlive: json['isAlive'] as bool?,
  dateOfDeath: json['dateOfDeath'] as String?,
  maritalStatus: $enumDecodeNullable(
    _$MaritalStatusEnumMap,
    json['maritalStatus'],
  ),
  generation: (json['generation'] as num?)?.toInt(),
  branchId: (json['branchId'] as num?)?.toInt(),
  branchName: json['branchName'] as String?,
  parentId: (json['parentId'] as num?)?.toInt(),
  spouseId: (json['spouseId'] as num?)?.toInt(),
  notes: json['notes'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
);

Map<String, dynamic> _$MemberModelToJson(_MemberModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'gender': _$GenderEnumMap[instance.gender],
      'dateOfBirth': instance.dateOfBirth,
      'placeOfBirth': instance.placeOfBirth,
      'isAlive': instance.isAlive,
      'dateOfDeath': instance.dateOfDeath,
      'maritalStatus': _$MaritalStatusEnumMap[instance.maritalStatus],
      'generation': instance.generation,
      'branchId': instance.branchId,
      'branchName': instance.branchName,
      'parentId': instance.parentId,
      'spouseId': instance.spouseId,
      'notes': instance.notes,
      'avatarUrl': instance.avatarUrl,
    };

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.other: 'other',
  Gender.unknown: 'unknown',
};

const _$MaritalStatusEnumMap = {
  MaritalStatus.single: 'single',
  MaritalStatus.married: 'married',
  MaritalStatus.divorced: 'divorced',
  MaritalStatus.widowed: 'widowed',
  MaritalStatus.unknown: 'unknown',
};
