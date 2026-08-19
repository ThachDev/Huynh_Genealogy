import 'package:equatable/equatable.dart';

class MemberDataEntity extends Equatable {

  const MemberDataEntity({
    this.fullName,
    this.gender,
    this.dateOfBirth,
    this.placeOfBirth,
    this.maritalStatus,
    this.education,
    this.avatarUrl,
    this.notes,
    this.parentId,
    this.spouseId,
  });
  final String? fullName;
  final String? gender;
  final String? dateOfBirth;
  final String? placeOfBirth;
  final String? maritalStatus;
  final String? education;
  final String? avatarUrl;
  final String? notes;
  final int? parentId;
  final int? spouseId;

  @override
  List<Object?> get props => [
        fullName,
        gender,
        dateOfBirth,
        placeOfBirth,
        maritalStatus,
        education,
        avatarUrl,
        notes,
        parentId,
        spouseId,
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
