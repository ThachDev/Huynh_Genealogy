import 'package:equatable/equatable.dart';

enum Gender { male, female, unknown }

enum MaritalStatus { single, married, divorced, widowed, unknown }

class MemberEntity extends Equatable {
  final int id;
  final String fullName;
  final Gender gender;
  final String? dateOfBirth;
  final String? placeOfBirth;
  final bool isAlive;
  final String? dateOfDeath;
  final MaritalStatus maritalStatus;
  final int? generation;
  final int? branchId;
  final String? branchName;
  final int? parentId;
  final int? motherId;
  final int? spouseId;
  final String? notes;
  final String? avatarUrl;
  final int? familyId;
  final String? lunarBirthDate;
  final String? lunarDeathDate;
  final String? phone;
  final String? education;
  final String? occupation;
  final String? deletedAt;

  const MemberEntity({
    required this.id,
    required this.fullName,
    required this.gender,
    this.dateOfBirth,
    this.placeOfBirth,
    this.isAlive = true,
    this.dateOfDeath,
    this.maritalStatus = MaritalStatus.unknown,
    this.generation,
    this.branchId,
    this.branchName,
    this.parentId,
    this.motherId,
    this.spouseId,
    this.notes,
    this.avatarUrl,
    this.familyId,
    this.lunarBirthDate,
    this.lunarDeathDate,
    this.phone,
    this.education,
    this.occupation,
    this.deletedAt,
  });

  @override
  List<Object?> get props => [
        id,
        fullName,
        gender,
        dateOfBirth,
        placeOfBirth,
        isAlive,
        dateOfDeath,
        maritalStatus,
        generation,
        branchId,
        branchName,
        parentId,
        motherId,
        spouseId,
        notes,
        avatarUrl,
        familyId,
        lunarBirthDate,
        lunarDeathDate,
        phone,
        education,
        occupation,
        deletedAt,
      ];

  MemberEntity copyWith({
    int? id,
    String? fullName,
    Gender? gender,
    String? dateOfBirth,
    String? placeOfBirth,
    bool? isAlive,
    String? dateOfDeath,
    MaritalStatus? maritalStatus,
    int? generation,
    int? branchId,
    String? branchName,
    int? parentId,
    int? motherId,
    int? spouseId,
    String? notes,
    String? avatarUrl,
    int? familyId,
    String? lunarBirthDate,
    String? lunarDeathDate,
    String? phone,
    String? education,
    String? occupation,
    String? deletedAt,
  }) {
    return MemberEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      placeOfBirth: placeOfBirth ?? this.placeOfBirth,
      isAlive: isAlive ?? this.isAlive,
      dateOfDeath: dateOfDeath ?? this.dateOfDeath,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      generation: generation ?? this.generation,
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
      parentId: parentId ?? this.parentId,
      motherId: motherId ?? this.motherId,
      spouseId: spouseId ?? this.spouseId,
      notes: notes ?? this.notes,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      familyId: familyId ?? this.familyId,
      lunarBirthDate: lunarBirthDate ?? this.lunarBirthDate,
      lunarDeathDate: lunarDeathDate ?? this.lunarDeathDate,
      phone: phone ?? this.phone,
      education: education ?? this.education,
      occupation: occupation ?? this.occupation,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
