// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FamilyEntityImpl _$$FamilyEntityImplFromJson(Map<String, dynamic> json) =>
    _$FamilyEntityImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      inviteCode: json['inviteCode'] as String,
      creatorId: (json['creatorId'] as num).toInt(),
      description: json['description'] as String?,
      origin: json['origin'] as String?,
      logoUrl: json['logoUrl'] as String?,
    );

Map<String, dynamic> _$$FamilyEntityImplToJson(_$FamilyEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'inviteCode': instance.inviteCode,
      'creatorId': instance.creatorId,
      'description': instance.description,
      'origin': instance.origin,
      'logoUrl': instance.logoUrl,
    };
