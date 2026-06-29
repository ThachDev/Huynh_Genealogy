import 'package:equatable/equatable.dart';
import 'package:giatocviet/core/domain/entity/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;

  const Authenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthCredentialsLoaded extends AuthState {
  final String? email;
  final String? password;

  const AuthCredentialsLoaded({this.email, this.password});

  @override
  List<Object?> get props => [email, password];
}
