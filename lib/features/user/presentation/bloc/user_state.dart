import 'package:equatable/equatable.dart';
import '../../../../core/domain/entity/user_entity.dart';

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
  final UserEntity profile;

  const UserLoadedState({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class UserUpdatingState extends UserState {
  const UserUpdatingState();
}

class UserUpdateSuccessState extends UserState {
  final UserEntity profile;
  final String message;

  const UserUpdateSuccessState({
    required this.profile,
    required this.message,
  });

  @override
  List<Object?> get props => [profile, message];
}

class UserErrorState extends UserState {
  final String message;

  const UserErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
