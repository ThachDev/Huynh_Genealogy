import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entity/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> loginWithGoogle();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, UserEntity?>> getCachedUser();
}
