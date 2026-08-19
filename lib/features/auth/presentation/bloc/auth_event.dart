import 'package:equatable/equatable.dart';
import 'package:giatocviet/core/domain/entity/user_entity.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthProfileRefreshRequested extends AuthEvent {}

class AuthProfileRefreshSilent extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {}

class AuthLoginWithEmailRequested extends AuthEvent {

  const AuthLoginWithEmailRequested({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthRegisterRequested extends AuthEvent {

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.fullName,
    required this.role,
  });
  final String email;
  final String password;
  final String fullName;
  final String role;

  @override
  List<Object?> get props => [email, password, fullName, role];
}

class AuthUserUpdated extends AuthEvent {

  const AuthUserUpdated({required this.user});
  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

class AuthLoadCredentialsRequested extends AuthEvent {}

class AuthCacheCredentialsRequested extends AuthEvent {

  const AuthCacheCredentialsRequested({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class AuthClearCredentialsRequested extends AuthEvent {}

class AuthForgotPasswordRequested extends AuthEvent {

  const AuthForgotPasswordRequested({required this.email});
  final String email;

  @override
  List<Object?> get props => [email];
}

class AuthVerifyOtpRequested extends AuthEvent {

  const AuthVerifyOtpRequested({required this.email, required this.otp});
  final String email;
  final String otp;

  @override
  List<Object?> get props => [email, otp];
}

class AuthResetPasswordRequested extends AuthEvent {

  const AuthResetPasswordRequested({
    required this.email,
    required this.otp,
    required this.newPassword,
  });
  final String email;
  final String otp;
  final String newPassword;

  @override
  List<Object?> get props => [email, otp, newPassword];
}
