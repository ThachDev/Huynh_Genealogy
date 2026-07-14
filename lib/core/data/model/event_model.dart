import '../../domain/entity/event_entity.dart';

class EventModel extends EventEntity {
  const EventModel({
    required super.id,
    required super.title,
    super.description,
    required super.eventDate,
    super.isLunar,
    required super.familyId,
    super.content,
    super.imageUrl,
    super.location,
    super.type,
    super.organizer,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: _parseInt(json['id']) ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      eventDate: json['eventDate'] as String? ?? '',
      isLunar: _parseBool(json['isLunar'] ?? false),
      familyId: _parseInt(json['familyId']) ?? 0,
      content: json['content'] as String?,
      imageUrl: json['imageUrl'] as String?,
      location: json['location'] as String?,
      type: json['type'] as String? ?? 'event',
      organizer: json['organizer'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id > 0) 'id': id,
      'title': title,
      'description': description,
      'eventDate': eventDate,
      'isLunar': isLunar,
      'familyId': familyId,
      'content': content,
      'imageUrl': imageUrl,
      'location': location,
      'type': type,
      'organizer': organizer,
    };
  }

  factory EventModel.fromEntity(EventEntity entity) {
    return EventModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      eventDate: entity.eventDate,
      isLunar: entity.isLunar,
      familyId: entity.familyId,
      content: entity.content,
      imageUrl: entity.imageUrl,
      location: entity.location,
      type: entity.type,
      organizer: entity.organizer,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return false;
  }
}
