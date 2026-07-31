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

  factory FamilyEntity.fromJson(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json);
    return FamilyEntity(
      id: (data['id'] as num?)?.toInt() ?? 0,
      name: (data['name'] as String?) ?? '',
      inviteCode: (data['inviteCode'] ?? data['invite_code'])?.toString() ?? '',
      creatorId:
          (data['creatorId'] ?? data['creator_id'] as num?)?.toInt() ?? 0,
      description: data['description']?.toString(),
      origin: data['origin']?.toString(),
      logoUrl: data['logoUrl']?.toString(),
    );
  }
}
