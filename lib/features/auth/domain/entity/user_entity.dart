import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String email;
  final String fullName;
  final String? avatarUrl;
  final String? fcmToken;
  final String role; // 'OWNER' | 'BRANCH_ADMIN' | 'EDITOR' | 'VIEWER'

  const UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    this.avatarUrl,
    this.fcmToken,
    this.role = 'VIEWER',
  });

  @override
  List<Object?> get props => [id, email, fullName, avatarUrl, fcmToken, role];
}
