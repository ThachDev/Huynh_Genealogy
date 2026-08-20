import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../repository/user_repository.dart';

class UpdateUserProfile implements UseCase<UserEntity, UpdateUserProfileParams> {

  UpdateUserProfile(this.repository);
  final UserRepository repository;

  @override
  Future<Either<Failure, UserEntity>> call(UpdateUserProfileParams params) {
    return repository.updateUserProfile(params.profile);
  }
}

class UpdateUserProfileParams extends Equatable {

  const UpdateUserProfileParams({required this.profile});
  final UserEntity profile;

  @override
  List<Object?> get props => [profile];
}
