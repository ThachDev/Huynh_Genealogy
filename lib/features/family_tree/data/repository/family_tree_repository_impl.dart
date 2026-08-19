import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import 'package:giatocviet/core/domain/entity/branch_entity.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import 'package:giatocviet/core/domain/entity/audit_log_entity.dart';
import 'package:giatocviet/core/data/model/member_model.dart';
import '../../domain/repository/family_tree_repository.dart';
import '../source/family_tree_remote_data_source.dart';
import '../source/family_tree_local_data_source.dart';

class FamilyTreeRepositoryImpl implements FamilyTreeRepository {

  FamilyTreeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  final FamilyTreeRemoteDataSource remoteDataSource;
  final FamilyTreeLocalDataSource localDataSource;

  // ---------- Members ----------

  @override
  Future<Either<Failure, List<MemberEntity>>> getMembers({int? branchId, int? familyId}) async {
    try {
      final models = await remoteDataSource.getMembers(branchId: branchId, familyId: familyId);
      if (branchId == null) {
        await localDataSource.cacheMembers(models, familyId);
      }
      return Right(models);
    } on ServerException catch (e) {
      return _membersFallback(e.message, branchId, familyId);
    } on NetworkException catch (e) {
      return _membersFallback(e.message, branchId, familyId);
    }
  }

  Future<Either<Failure, List<MemberEntity>>> _membersFallback(
    String? message,
    int? branchId,
    int? familyId,
  ) async {
    final cached = await localDataSource.getCachedMembers(familyId);
    if (cached != null) {
      if (branchId != null) {
        return Right(cached.where((m) => m.branchId == branchId).toList());
      }
      return Right(cached);
    }
    return Left(NetworkFailure(message: message));
  }

  @override
  Future<List<MemberEntity>?> getCachedMembers({int? familyId}) async {
    return localDataSource.getCachedMembers(familyId);
  }

  @override
  Future<Either<Failure, MemberEntity>> getMemberById(int id) async {
    try {
      final model = await remoteDataSource.getMemberById(id);
      return Right(model);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } catch (e) {
      return Left(ErrorHandler.map(e));
    }
  }

  @override
  Future<Either<Failure, MemberEntity>> saveMember(MemberEntity member) async {
    try {
      final model = MemberModel.fromEntity(member);
      final saved = await remoteDataSource.saveMember(model);
      await localDataSource.clearAll();
      return Right(saved);
    } catch (e) {
      return Left(ErrorHandler.map(e));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteMember(int id, {bool reassignChildrenToParent = false}) async {
    try {
      final result = await remoteDataSource.deleteMember(id, reassignChildrenToParent: reassignChildrenToParent);
      await localDataSource.clearAll();
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.map(e));
    }
  }

  @override
  Future<Either<Failure, List<MemberEntity>>> getTrashedMembers({int? familyId, int? branchId}) async {
    try {
      final models = await remoteDataSource.getTrashedMembers(familyId: familyId, branchId: branchId);
      return Right(models);
    } catch (e) {
      return Left(ErrorHandler.map(e));
    }
  }

  @override
  Future<Either<Failure, MemberEntity>> restoreMember(int id) async {
    try {
      final model = await remoteDataSource.restoreMember(id);
      await localDataSource.clearAll();
      return Right(model);
    } catch (e) {
      return Left(ErrorHandler.map(e));
    }
  }

  @override
  Future<Either<Failure, int>> purgeTrash({int days = 30}) async {
    try {
      final count = await remoteDataSource.purgeTrash(days: days);
      await localDataSource.clearAll();
      return Right(count);
    } catch (e) {
      return Left(ErrorHandler.map(e));
    }
  }

  @override
  Future<Either<Failure, List<AuditLogEntity>>> getAuditLogs({int? familyId, int? limit}) async {
    try {
      final models = await remoteDataSource.getAuditLogs(familyId: familyId, limit: limit);
      return Right(models);
    } catch (e) {
      return Left(ErrorHandler.map(e));
    }
  }

  // ---------- Branches ----------

  @override
  Future<Either<Failure, List<BranchEntity>>> getBranches({int? familyId}) async {
    try {
      final models = await remoteDataSource.getBranches(familyId: familyId);
      await localDataSource.cacheBranches(models, familyId);
      return Right(models);
    } on ServerException catch (e) {
      return _branchesFallback(e.message, familyId);
    } on NetworkException catch (e) {
      return _branchesFallback(e.message, familyId);
    }
  }

  Future<Either<Failure, List<BranchEntity>>> _branchesFallback(
    String? message,
    int? familyId,
  ) async {
    final cached = await localDataSource.getCachedBranches(familyId);
    if (cached != null) {
      return Right(cached);
    }
    return Left(NetworkFailure(message: message));
  }

  @override
  Future<List<BranchEntity>?> getCachedBranches({int? familyId}) async {
    return localDataSource.getCachedBranches(familyId);
  }

  @override
  Future<Either<Failure, BranchEntity>> getBranchById(int id) async {
    try {
      final model = await remoteDataSource.getBranchById(id);
      return Right(model);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } catch (e) {
      return Left(ErrorHandler.map(e));
    }
  }

  @override
  Future<Either<Failure, BranchEntity>> saveBranch(BranchEntity branch) async {
    try {
      final saved = await remoteDataSource.saveBranch(branch);
      await localDataSource.clearAll();
      return Right(saved);
    } catch (e) {
      return Left(ErrorHandler.map(e));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteBranch(int id) async {
    try {
      final result = await remoteDataSource.deleteBranch(id);
      await localDataSource.clearAll();
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.map(e));
    }
  }
}
