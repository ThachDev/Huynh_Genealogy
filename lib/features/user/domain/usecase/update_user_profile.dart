import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/domain/entity/user_entity.dart';
import '../repository/user_repository.dart';

class UpdateUserProfile implements UseCase<UserEntity, UpdateUserProfileParams> {
  final UserRepository repository;

  UpdateUserProfile(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateUserProfileParams params) {
    return repository.updateUserProfile(params.profile);
  }
}

class UpdateUserProfileParams extends Equatable {
  final UserEntity profile;

  const UpdateUserProfileParams({required this.profile});

  @override
  List<Object?> get props => [profile];
}
