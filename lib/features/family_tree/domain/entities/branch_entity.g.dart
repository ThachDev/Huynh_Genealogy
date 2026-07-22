// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BranchEntityImpl _$$BranchEntityImplFromJson(Map<String, dynamic> json) =>
    _$BranchEntityImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      founderName: json['founderName'] as String?,
      foundingYear: (json['foundingYear'] as num?)?.toInt(),
      region: json['region'] as String?,
      familyId: (json['familyId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$BranchEntityImplToJson(_$BranchEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'founderName': instance.founderName,
      'foundingYear': instance.foundingYear,
      'region': instance.region,
      'familyId': instance.familyId,
    };
