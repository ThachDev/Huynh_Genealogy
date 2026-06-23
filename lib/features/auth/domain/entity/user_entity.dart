import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String email;
  final String fullName;
  final String? avatarUrl;
  final String? fcmToken;
  final String role; // 'OWNER' | 'BRANCH_ADMIN' | 'EDITOR' | 'VIEWER'
  final int? familyId;

  const UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    this.avatarUrl,
    this.fcmToken,
    this.role = 'VIEWER',
    this.familyId,
  });

  @override
  List<Object?> get props => [id, email, fullName, avatarUrl, fcmToken, role, familyId];

  UserEntity copyWith({
    int? id,
    String? email,
    String? fullName,
    String? avatarUrl,
    String? fcmToken,
    String? role,
    int? familyId,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      fcmToken: fcmToken ?? this.fcmToken,
      role: role ?? this.role,
      familyId: familyId ?? this.familyId,
    );
  }
}
