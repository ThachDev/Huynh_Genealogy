import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user_entity.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class FetchUserProfileEvent extends UserEvent {
  const FetchUserProfileEvent();
}

class UpdateUserProfileEvent extends UserEvent {

  const UpdateUserProfileEvent(this.profile);
  final UserEntity profile;

  @override
  List<Object?> get props => [profile];
}
