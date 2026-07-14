import '../../domain/entity/event_entity.dart';

class EventModel extends EventEntity {
  const EventModel({
    required super.id,
    required super.title,
    super.description,
    required super.eventDate,
    super.isLunar,
    required super.familyId,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: _parseInt(json['id']) ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      eventDate: json['eventDate'] as String? ?? '',
      isLunar: _parseBool(json['isLunar'] ?? false),
      familyId: _parseInt(json['familyId']) ?? 0,
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
