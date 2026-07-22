// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventEntityImpl _$$EventEntityImplFromJson(Map<String, dynamic> json) =>
    _$EventEntityImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String?,
      eventDate: json['eventDate'] as String,
      isLunar: json['isLunar'] as bool? ?? false,
      familyId: (json['familyId'] as num).toInt(),
      content: json['content'] as String?,
      imageUrl: json['imageUrl'] as String?,
      location: json['location'] as String?,
      type: json['type'] as String? ?? 'event',
      organizer: json['organizer'] as String?,
    );

Map<String, dynamic> _$$EventEntityImplToJson(_$EventEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'eventDate': instance.eventDate,
      'isLunar': instance.isLunar,
      'familyId': instance.familyId,
      'content': instance.content,
      'imageUrl': instance.imageUrl,
      'location': instance.location,
      'type': instance.type,
      'organizer': instance.organizer,
    };
