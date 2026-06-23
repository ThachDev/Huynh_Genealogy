import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String email;
  final String fullName;
  final String? avatarUrl;
  final String? fcmToken;

  const UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    this.avatarUrl,
    this.fcmToken,
  });

  @override
  List<Object?> get props => [id, email, fullName, avatarUrl, fcmToken];
}
