import 'package:equatable/equatable.dart';
import '../../domain/entity/user_entity.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {}

class AuthLogoutRequested extends AuthEvent {}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  final String role;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.fullName,
    required this.role,
  });

  @override
  List<Object?> get props => [email, password, fullName, role];
}

class AuthUserUpdated extends AuthEvent {
  final UserEntity user;

  const AuthUserUpdated({required this.user});

  @override
  List<Object?> get props => [user];
}
