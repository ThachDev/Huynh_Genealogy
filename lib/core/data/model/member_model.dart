import '../../domain/entity/member_entity.dart';

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
    super.familyId,
    super.isLunarBirthDate,
    super.isLunarDeathDate,
    super.phone,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: _parseInt(json['id']) ?? 0,
      fullName: json['fullName'] as String? ?? '',
      gender: _parseGender(json['gender'] as String?),
      dateOfBirth: json['dateOfBirth'] as String?,
      placeOfBirth: json['placeOfBirth'] as String?,
      isAlive: _parseBool(json['isAlive'] ?? true),
      dateOfDeath: json['dateOfDeath'] as String?,
      maritalStatus: _parseMaritalStatus(json['maritalStatus'] as String?),
      generation: _parseInt(json['generation']),
      branchId: _parseInt(json['branchId']),
      branchName: json['branchName'] as String?,
      parentId: _parseInt(json['parentId']),
      spouseId: _parseInt(json['spouseId']),
      notes: json['notes'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      familyId: _parseInt(json['familyId']),
      isLunarBirthDate: _parseBool(json['isLunarBirthDate']),
      isLunarDeathDate: _parseBool(json['isLunarDeathDate']),
      phone: json['phone'] as String?,
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
      'familyId': familyId,
      'isLunarBirthDate': isLunarBirthDate,
      'isLunarDeathDate': isLunarDeathDate,
      'phone': phone,
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
      familyId: entity.familyId,
      isLunarBirthDate: entity.isLunarBirthDate,
      isLunarDeathDate: entity.isLunarDeathDate,
      phone: entity.phone,
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
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return false;
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
