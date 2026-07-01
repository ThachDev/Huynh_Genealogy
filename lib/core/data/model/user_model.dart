import '../../domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    super.avatarUrl,
    super.fcmToken,
    super.role = 'VIEWER',
    super.familyId,
    super.memberId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      fcmToken: json['fcmToken'] as String?,
      role: json['role'] as String? ?? 'VIEWER',
      familyId: json['familyId'] as int?,
      memberId: json['memberId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'avatarUrl': avatarUrl,
      'fcmToken': fcmToken,
      'role': role,
      'familyId': familyId,
      'memberId': memberId,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      fullName: entity.fullName,
      avatarUrl: entity.avatarUrl,
      fcmToken: entity.fcmToken,
      role: entity.role,
      familyId: entity.familyId,
      memberId: entity.memberId,
    );
  }

  @override
  UserModel copyWith({
    int? id,
    String? email,
    String? fullName,
    String? avatarUrl,
    String? fcmToken,
    String? role,
    int? familyId,
    int? memberId,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      fcmToken: fcmToken ?? this.fcmToken,
      role: role ?? this.role,
      familyId: familyId ?? this.familyId,
      memberId: memberId ?? this.memberId,
    );
  }
}
