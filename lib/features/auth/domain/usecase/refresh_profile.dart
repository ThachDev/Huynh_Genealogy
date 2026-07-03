import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:giatocviet/core/domain/entity/user_entity.dart';
import '../repository/auth_repository.dart';

class RefreshProfile implements UseCase<UserEntity, NoParams> {
  final AuthRepository repository;

  RefreshProfile(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) {
    return repository.refreshProfile();
  }
}
