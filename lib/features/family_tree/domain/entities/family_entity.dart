import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_entity.freezed.dart';
part 'family_entity.g.dart';

@freezed
class FamilyEntity with _$FamilyEntity {
  const factory FamilyEntity({
    required int id,
    required String name,
    required String inviteCode,
    required int creatorId,
    String? description,
    String? origin,
    String? logoUrl,
  }) = _FamilyEntity;

  factory FamilyEntity.fromJson(Map<String, dynamic> json) =>
      _$FamilyEntityFromJson(json);
}
