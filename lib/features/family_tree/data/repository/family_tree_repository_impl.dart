import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import 'package:giatocviet/core/domain/entity/branch_entity.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import 'package:giatocviet/core/data/model/branch_model.dart';
import 'package:giatocviet/core/data/model/member_model.dart';
import '../../domain/repository/family_tree_repository.dart';
import '../source/family_tree_remote_data_source.dart';

class FamilyTreeRepositoryImpl implements FamilyTreeRepository {
  final FamilyTreeRemoteDataSource remoteDataSource;

  FamilyTreeRepositoryImpl({required this.remoteDataSource});

  // ---------- Members ----------

  @override
  Future<Either<Failure, List<MemberEntity>>> getMembers({int? branchId, int? familyId}) async {
    try {
      final models = await remoteDataSource.getMembers(branchId: branchId, familyId: familyId);
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
  Future<Either<Failure, List<BranchEntity>>> getBranches({int? familyId}) async {
    try {
      final models = await remoteDataSource.getBranches(familyId: familyId);
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
