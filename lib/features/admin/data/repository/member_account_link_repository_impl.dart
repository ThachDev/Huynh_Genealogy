import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/member_account_link_entity.dart';
import '../../domain/repository/member_account_link_repository.dart';
import '../source/member_account_link_remote_data_source.dart';

class MemberAccountLinkRepositoryImpl implements MemberAccountLinkRepository {
  final MemberAccountLinkRemoteDataSource remoteDataSource;

  MemberAccountLinkRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MemberAccountLinkEntity>>> getAccountLinks(
    int familyId,
  ) async {
    try {
      final result = await remoteDataSource.getAccountLinks(familyId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, LinkAccountResult>> linkMemberAccount({
    required int familyId,
    required int memberId,
    required String email,
  }) async {
    try {
      final result = await remoteDataSource.linkMember(
        memberId: memberId,
        email: email,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> unlinkMember({
    required int familyId,
    required int memberId,
  }) async {
    try {
      final result = await remoteDataSource.unlinkMember(memberId: memberId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }
}