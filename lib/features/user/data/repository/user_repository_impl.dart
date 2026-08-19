import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/domain/entity/user_entity.dart';
import '../../domain/repository/user_repository.dart';
import '../source/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {

  UserRepositoryImpl({required this.remoteDataSource});
  final UserRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, UserEntity>> getUserProfile() async {
    try {
      final profile = await remoteDataSource.getUserProfile();
      return Right(profile);
    } catch (e) {
      return Left(ErrorHandler.map(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserProfile(UserEntity profile) async {
    try {
      final updated = await remoteDataSource.updateUserProfile(profile);
      return Right(updated);
    } catch (e) {
      return Left(ErrorHandler.map(e));
    }
  }
}
