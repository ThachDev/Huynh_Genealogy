import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user_entity.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitialState extends UserState {
  const UserInitialState();
}

class UserLoadingState extends UserState {
  const UserLoadingState();
}

class UserLoadedState extends UserState {

  const UserLoadedState({required this.profile});
  final UserEntity profile;

  @override
  List<Object?> get props => [profile];
}

class UserUpdatingState extends UserState {
  const UserUpdatingState();
}

class UserUpdateSuccessState extends UserState {

  const UserUpdateSuccessState({
    required this.profile,
    required this.message,
  });
  final UserEntity profile;
  final String message;

  @override
  List<Object?> get props => [profile, message];
}

class UserErrorState extends UserState {

  const UserErrorState({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
