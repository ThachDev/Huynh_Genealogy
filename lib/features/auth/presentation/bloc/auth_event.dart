import 'package:equatable/equatable.dart';
import 'package:giatocviet/core/domain/entity/user_entity.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {}

class AuthLoginWithEmailRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginWithEmailRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

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

class AuthLoadCredentialsRequested extends AuthEvent {}

class AuthCacheCredentialsRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthCacheCredentialsRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class AuthClearCredentialsRequested extends AuthEvent {}

class AuthForgotPasswordRequested extends AuthEvent {
  final String email;

  const AuthForgotPasswordRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthVerifyOtpRequested extends AuthEvent {
  final String email;
  final String otp;

  const AuthVerifyOtpRequested({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}

class AuthResetPasswordRequested extends AuthEvent {
  final String email;
  final String otp;
  final String newPassword;

  const AuthResetPasswordRequested({
    required this.email,
    required this.otp,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, otp, newPassword];
}
