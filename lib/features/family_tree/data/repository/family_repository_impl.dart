import 'package:dartz/dartz.dart';
import 'package:app_family_tree/exception_handler/exceptions.dart';
import 'package:app_family_tree/exception_handler/failures.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/branch.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/member.dart';
import 'package:app_family_tree/features/family_tree/domain/repositories/family_repository.dart';
import 'package:app_family_tree/features/family_tree/data/source/family_data_source.dart';
import 'package:app_family_tree/features/family_tree/data/model/branch_model.dart';
import 'package:app_family_tree/features/family_tree/data/model/member_model.dart';

class FamilyRepositoryImpl implements FamilyRepository {
  /// Có thể là FamilyLocalDataSourceImpl hoặc FamilyRemoteDataSourceImpl
  final FamilyDataSource dataSource;

  FamilyRepositoryImpl({required this.dataSource});

  // ─── Members ──────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<MemberEntity>>> getMembers({
    int? branchId,
  }) async {
    try {
      final models = await dataSource.getMembers(branchId: branchId);
      return Right(models);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MemberEntity>> getMemberById(int id) async {
    try {
      final model = await dataSource.getMemberById(id);
      return Right(model);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MemberEntity>> saveMember(MemberEntity member) async {
    try {
      final model = MemberModel.fromEntity(member);
      final saved = await dataSource.saveMember(model);
      return Right(saved);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteMember(int id) async {
    try {
      final result = await dataSource.deleteMember(id);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ─── Branches ─────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<BranchEntity>>> getBranches() async {
    try {
      final models = await dataSource.getBranches();
      return Right(models);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BranchEntity>> getBranchById(int id) async {
    try {
      final model = await dataSource.getBranchById(id);
      return Right(model);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BranchEntity>> saveBranch(BranchEntity branch) async {
    try {
      final model = BranchModel.fromEntity(branch);
      final saved = await dataSource.saveBranch(model);
      return Right(saved);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteBranch(int id) async {
    try {
      final result = await dataSource.deleteBranch(id);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
