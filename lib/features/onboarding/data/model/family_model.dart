import '../../domain/entity/family_entity.dart';

class FamilyModel extends FamilyEntity {
  const FamilyModel({
    required super.id,
    required super.name,
    required super.inviteCode,
    required super.creatorId,
    super.description,
    super.coverImageUrl,
  });

  factory FamilyModel.fromJson(Map<String, dynamic> json) {
    return FamilyModel(
      id: json['id'] as int,
      name: json['name'] as String,
      inviteCode: json['inviteCode'] as String? ?? '',
      creatorId: json['creatorId'] as int? ?? 0,
      description: json['description'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'inviteCode': inviteCode,
      'creatorId': creatorId,
      'description': description,
      'coverImageUrl': coverImageUrl,
    };
  }

  factory FamilyModel.fromEntity(FamilyEntity entity) {
    return FamilyModel(
      id: entity.id,
      name: entity.name,
      inviteCode: entity.inviteCode,
      creatorId: entity.creatorId,
      description: entity.description,
      coverImageUrl: entity.coverImageUrl,
    );
  }
}
