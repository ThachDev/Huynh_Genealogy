import 'package:equatable/equatable.dart';

/// Giới tính
enum Gender { male, female, unknown }

/// Trạng thái hôn nhân
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
  final int? generation;          // Thế hệ (1, 2, 3,...)
  final int? branchId;            // Chi/Nhánh
  final String? branchName;
  final int? parentId;            // ID cha
  final int? spouseId;            // ID vợ/chồng
  final String? notes;
  final String? avatarUrl;

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
    this.spouseId,
    this.notes,
    this.avatarUrl,
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
        spouseId,
        notes,
        avatarUrl,
      ];
}






