import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/domain/entity/user_entity.dart';
import '../repository/user_repository.dart';

class GetUserProfile implements UseCase<UserEntity, NoParams> {
  final UserRepository repository;

  GetUserProfile(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) {
    return repository.getUserProfile();
  }
}
