import 'package:equatable/equatable.dart';
import '../../../../core/domain/entity/user_entity.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class FetchUserProfileEvent extends UserEvent {
  const FetchUserProfileEvent();
}

class UpdateUserProfileEvent extends UserEvent {
  final UserEntity profile;

  const UpdateUserProfileEvent(this.profile);

  @override
  List<Object?> get props => [profile];
}
