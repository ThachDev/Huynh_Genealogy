import 'package:equatable/equatable.dart';
import 'package:giatocviet/features/auth/domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {

  const Authenticated({required this.user});
  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {

  const AuthError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}

class AuthCredentialsLoaded extends AuthState {

  const AuthCredentialsLoaded({this.email, this.password});
  final String? email;
  final String? password;

  @override
  List<Object?> get props => [email, password];
}

class AuthForgotPasswordSent extends AuthState {}

class AuthOtpVerified extends AuthState {}

class AuthResetPasswordSuccess extends AuthState {}
