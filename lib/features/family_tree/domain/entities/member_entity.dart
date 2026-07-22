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
      ];
}
