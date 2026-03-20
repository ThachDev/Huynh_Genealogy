// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BranchModel _$BranchModelFromJson(Map<String, dynamic> json) => _BranchModel(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  description: json['description'] as String?,
  founderName: json['founderName'] as String?,
  foundingYear: (json['foundingYear'] as num?)?.toInt(),
  region: json['region'] as String?,
);

Map<String, dynamic> _$BranchModelToJson(_BranchModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'founderName': instance.founderName,
      'foundingYear': instance.foundingYear,
      'region': instance.region,
    };
