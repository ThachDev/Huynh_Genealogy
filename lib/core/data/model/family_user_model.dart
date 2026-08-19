import '../../domain/entity/family_user_entity.dart';

class FamilyUserModel extends FamilyUserEntity {
  const FamilyUserModel({
    required super.id,
    required super.userId,
    required super.familyId,
    super.memberNodeId,
    required super.role,
    required super.status,
    super.userFullName,
    super.userEmail,
    super.userAvatarUrl,
    super.memberData,
  });

  factory FamilyUserModel.fromEntity(FamilyUserEntity entity) {
    return FamilyUserModel(
      id: entity.id,
      userId: entity.userId,
      familyId: entity.familyId,
      memberNodeId: entity.memberNodeId,
      role: entity.role,
      status: entity.status,
      userFullName: entity.userFullName,
      userEmail: entity.userEmail,
      userAvatarUrl: entity.userAvatarUrl,
      memberData: entity.memberData,
    );
  }

  factory FamilyUserModel.fromJson(Map<String, dynamic> json) {
    // Thông tin user (từ join với bảng users)
    final userJson = json['user'] as Map<String, dynamic>?;

    // Thông tin thành viên (từ join với bảng members)
    final memberJson = json['memberData'] as Map<String, dynamic>?;
    MemberDataEntity? memberData;
    if (memberJson != null) {
      memberData = MemberDataEntity(
        fullName: memberJson['fullName'] as String?,
        gender: memberJson['gender'] as String?,
        dateOfBirth: memberJson['dateOfBirth'] as String?,
        placeOfBirth: memberJson['placeOfBirth'] as String?,
        maritalStatus: memberJson['maritalStatus'] as String?,
        education: memberJson['education'] as String?,
        avatarUrl: memberJson['avatarUrl'] as String?,
        notes: memberJson['notes'] as String?,
        parentId: memberJson['parentId'] as int?,
        spouseId: memberJson['spouseId'] as int?,
      );
    }

    return FamilyUserModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      familyId: json['familyId'] as int,
      memberNodeId: json['memberNodeId'] as int?,
      role: json['role'] as String? ?? 'VIEWER',
      status: json['status'] as String? ?? 'PENDING',
      userFullName: userJson != null
          ? userJson['fullName'] as String?
          : json['userFullName'] as String?,
      userEmail: userJson != null
          ? userJson['email'] as String?
          : json['userEmail'] as String?,
      userAvatarUrl: userJson != null
          ? userJson['avatarUrl'] as String?
          : json['userAvatarUrl'] as String?,
      memberData: memberData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'familyId': familyId,
      'memberNodeId': memberNodeId,
      'role': role,
      'status': status,
      'userFullName': userFullName,
      'userEmail': userEmail,
      'userAvatarUrl': userAvatarUrl,
    };
  }
}
