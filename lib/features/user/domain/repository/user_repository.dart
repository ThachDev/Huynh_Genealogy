import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/domain/entity/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> getUserProfile();
  Future<Either<Failure, UserEntity>> updateUserProfile(UserEntity profile);
}
