import 'package:app_family_tree/features/family_tree/domain/entities/member.dart';

class MemberModel extends MemberEntity {
  const MemberModel({
    required super.id,
    required super.fullName,
    required super.gender,
    super.dateOfBirth,
    super.placeOfBirth,
    super.isAlive,
    super.dateOfDeath,
    super.maritalStatus,
    super.generation,
    super.branchId,
    super.branchName,
    super.parentId,
    super.spouseId,
    super.notes,
    super.avatarUrl,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'] as int,
      fullName: json['fullName'] as String,
      gender: _parseGender(json['gender'] as String?),
      dateOfBirth: json['dateOfBirth'] as String?,
      placeOfBirth: json['placeOfBirth'] as String?,
      isAlive: json['isAlive'] as bool? ?? true,
      dateOfDeath: json['dateOfDeath'] as String?,
      maritalStatus: _parseMaritalStatus(json['maritalStatus'] as String?),
      generation: json['generation'] as int?,
      branchId: json['branchId'] as int?,
      branchName: json['branchName'] as String?,
      parentId: json['parentId'] as int?,
      spouseId: json['spouseId'] as int?,
      notes: json['notes'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'gender': gender.name,
      'dateOfBirth': dateOfBirth,
      'placeOfBirth': placeOfBirth,
      'isAlive': isAlive,
      'dateOfDeath': dateOfDeath,
      'maritalStatus': maritalStatus.name,
      'generation': generation,
      'branchId': branchId,
      'parentId': parentId,
      'spouseId': spouseId,
      'notes': notes,
      'avatarUrl': avatarUrl,
    };
  }

  factory MemberModel.fromEntity(MemberEntity entity) {
    return MemberModel(
      id: entity.id,
      fullName: entity.fullName,
      gender: entity.gender,
      dateOfBirth: entity.dateOfBirth,
      placeOfBirth: entity.placeOfBirth,
      isAlive: entity.isAlive,
      dateOfDeath: entity.dateOfDeath,
      maritalStatus: entity.maritalStatus,
      generation: entity.generation,
      branchId: entity.branchId,
      branchName: entity.branchName,
      parentId: entity.parentId,
      spouseId: entity.spouseId,
      notes: entity.notes,
      avatarUrl: entity.avatarUrl,
    );
  }

  static Gender _parseGender(String? value) {
    switch (value?.toLowerCase()) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      default:
        return Gender.unknown;
    }
  }

  static MaritalStatus _parseMaritalStatus(String? value) {
    switch (value?.toLowerCase()) {
      case 'single':
        return MaritalStatus.single;
      case 'married':
        return MaritalStatus.married;
      case 'divorced':
        return MaritalStatus.divorced;
      case 'widowed':
        return MaritalStatus.widowed;
      default:
        return MaritalStatus.unknown;
    }
  }
}
