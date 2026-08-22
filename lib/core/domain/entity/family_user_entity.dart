import 'package:equatable/equatable.dart';

class MemberDataEntity extends Equatable {

  const MemberDataEntity({
    this.id,
    this.fullName,
    this.gender,
    this.dateOfBirth,
    this.generation,
    this.placeOfBirth,
    this.maritalStatus,
    this.education,
    this.occupation,
    this.phone,
    this.avatarUrl,
    this.notes,
    this.parentId,
    this.spouseId,
    this.branchName,
    this.parentName,
    this.spouseName,
  });
  final int? id;
  final String? fullName;
  final String? gender;
  final String? dateOfBirth;
  final int? generation;
  final String? placeOfBirth;
  final String? maritalStatus;
  final String? education;
  final String? occupation;
  final String? phone;
  final String? avatarUrl;
  final String? notes;
  final int? parentId;
  final int? spouseId;
  final String? branchName;
  final String? parentName;
  final String? spouseName;

  @override
  List<Object?> get props => [
        id,
        fullName,
        gender,
        dateOfBirth,
        generation,
        placeOfBirth,
        maritalStatus,
        education,
        occupation,
        phone,
        avatarUrl,
        notes,
        parentId,
        spouseId,
        branchName,
        parentName,
        spouseName,
      ];
}

class FamilyUserEntity extends Equatable {

  const FamilyUserEntity({
    required this.id,
    required this.userId,
    required this.familyId,
    this.memberNodeId,
    required this.role,
    required this.status,
    this.userFullName,
    this.userEmail,
    this.userAvatarUrl,
    this.memberData,
  });
  final int id;
  final int userId;
  final int familyId;
  final int? memberNodeId;
  final String role; // 'OWNER' | 'EDITOR' | 'VIEWER'
  final String status; // 'PENDING' | 'APPROVED' | 'REJECTED'
  final String? userFullName;
  final String? userEmail;
  final String? userAvatarUrl;
  // Thông tin thành viên mà user đã điền khi gửi yêu cầu
  final MemberDataEntity? memberData;

  @override
  List<Object?> get props => [
        id,
        userId,
        familyId,
        memberNodeId,
        role,
        status,
        userFullName,
        userEmail,
        userAvatarUrl,
        memberData,
      ];
}
