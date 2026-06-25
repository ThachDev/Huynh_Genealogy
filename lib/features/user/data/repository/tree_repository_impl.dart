import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entity/branch_entity.dart';
import '../../domain/entity/member_entity.dart';
import '../../domain/repository/tree_repository.dart';
import '../model/branch_model.dart';
import '../model/member_model.dart';
import '../source/tree_remote_data_source.dart';

class TreeRepositoryImpl implements TreeRepository {
  final TreeRemoteDataSource remoteDataSource;

  TreeRepositoryImpl({required this.remoteDataSource});

  // ---------- Members ----------

  @override
  Future<Either<Failure, List<MemberEntity>>> getMembers({int? branchId}) async {
    try {
      final models = await remoteDataSource.getMembers(branchId: branchId);
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, MemberEntity>> getMemberById(int id) async {
    try {
      final model = await remoteDataSource.getMemberById(id);
      return Right(model);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, MemberEntity>> saveMember(MemberEntity member) async {
    try {
      final model = MemberModel.fromEntity(member);
      final saved = await remoteDataSource.saveMember(model);
      return Right(saved);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteMember(int id) async {
    try {
      final result = await remoteDataSource.deleteMember(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  // ---------- Branches ----------

  @override
  Future<Either<Failure, List<BranchEntity>>> getBranches() async {
    try {
      final models = await remoteDataSource.getBranches();
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, BranchEntity>> getBranchById(int id) async {
    try {
      final model = await remoteDataSource.getBranchById(id);
      return Right(model);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, BranchEntity>> saveBranch(BranchEntity branch) async {
    try {
      final model = BranchModel.fromEntity(branch);
      final saved = await remoteDataSource.saveBranch(model);
      return Right(saved);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteBranch(int id) async {
    try {
      final result = await remoteDataSource.deleteBranch(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }
}
