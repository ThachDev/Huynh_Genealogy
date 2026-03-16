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
    int? asInt(dynamic v) => v is int ? v : (v is String ? int.tryParse(v) : null);

    return MemberModel(
      id: asInt(json['id']) ?? 0,
      fullName: json['fullName'] ?? '',
      gender: _parseGender(json['gender']),
      dateOfBirth: json['dateOfBirth']?.toString().split('T')[0],
      placeOfBirth: json['placeOfBirth'],
      isAlive: json['isAlive'] ?? true,
      dateOfDeath: json['dateOfDeath']?.toString().split('T')[0],
      maritalStatus: _parseMaritalStatus(json['maritalStatus']),
      generation: asInt(json['generation']),
      branchId: asInt(json['branchId']),
      branchName: json['branchName'],
      parentId: asInt(json['parentId']) ?? asInt(json['parent']?['id']),
      spouseId: asInt(json['spouseId']) ?? asInt(json['spouse']?['id']),
      notes: json['notes'],
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      if (id != 0) 'id': id,
      'fullName': fullName,
      'gender': gender.name,
      'dateOfBirth': dateOfBirth,
      'placeOfBirth': placeOfBirth,
      'isAlive': isAlive,
      'dateOfDeath': dateOfDeath,
      'maritalStatus': maritalStatus.name,
      'generation': generation ?? 1,
      'parentId': parentId,
      'spouseId': spouseId,
      'branchId': branchId,
      'notes': notes,
    };

    // Filter null values for Multipart compatibility
    return data..removeWhere((_, value) => value == null);
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
