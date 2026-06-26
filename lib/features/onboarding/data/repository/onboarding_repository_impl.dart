import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/domain/entity/family_entity.dart';
import '../../../../core/domain/entity/family_user_entity.dart';
import '../../domain/repository/onboarding_repository.dart';
import '../source/onboarding_remote_data_source.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingRemoteDataSource remoteDataSource;

  OnboardingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, FamilyEntity>> createFamily({
    required String name,
    String? description,
    String? coverImageUrl,
    required int userId,
  }) async {
    try {
      final familyModel = await remoteDataSource.createFamily(
        name: name,
        description: description,
        coverImageUrl: coverImageUrl,
        userId: userId,
      );
      return Right(familyModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> verifyInviteCode({
    required String code,
  }) async {
    try {
      final result = await remoteDataSource.verifyInviteCode(code);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, FamilyUserEntity>> joinFamily({
    required int userId,
    required int familyId,
    int? memberNodeId,
  }) async {
    try {
      final familyUserModel = await remoteDataSource.joinFamily(
        userId: userId,
        familyId: familyId,
        memberNodeId: memberNodeId,
      );
      return Right(familyUserModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<FamilyUserEntity>>> getPendingRequests({
    required int familyId,
  }) async {
    try {
      final list = await remoteDataSource.getPendingRequests(familyId);
      return Right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> approveRequest({
    required int requestId,
  }) async {
    try {
      final result = await remoteDataSource.approveRequest(requestId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }
}
