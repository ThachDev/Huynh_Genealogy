import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_entity.freezed.dart';
part 'event_entity.g.dart';

@freezed
class EventEntity with _$EventEntity {
  const factory EventEntity({
    required int id,
    required String title,
    String? description,
    required String eventDate,
    @Default(false) bool isLunar,
    required int familyId,
    String? content,
    String? imageUrl,
    String? location,
    @Default('event') String type,
    String? organizer,
  }) = _EventEntity;

  factory EventEntity.fromJson(Map<String, dynamic> json) =>
      _$EventEntityFromJson(json);
}
