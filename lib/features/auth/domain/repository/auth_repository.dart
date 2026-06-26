import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import 'package:giatocviet/core/domain/entity/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> loginWithGoogle();
  Future<Either<Failure, UserEntity>> loginWithEmail({
    required String email,
    required String password,
  });
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, UserEntity?>> getCachedUser();
  Future<Either<Failure, UserEntity>> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String role,
  });
  Future<Either<Failure, void>> cacheUser(UserEntity user);
}
