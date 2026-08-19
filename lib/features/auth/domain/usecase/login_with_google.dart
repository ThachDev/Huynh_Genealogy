import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:giatocviet/core/domain/entity/user_entity.dart';
import '../repository/auth_repository.dart';

class LoginWithGoogle implements UseCase<UserEntity, NoParams> {

  LoginWithGoogle(this.repository);
  final AuthRepository repository;

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) {
    return repository.loginWithGoogle();
  }
}
