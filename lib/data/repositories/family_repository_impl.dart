import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/branch_entity.dart';
import '../../domain/entities/member_entity.dart';
import '../../domain/entities/family_entity.dart';
import '../../domain/entities/family_user_entity.dart';
import '../../domain/repositories/family_repository.dart';
import '../datasources/family_remote_data_source.dart';
import '../models/branch_model.dart';
import '../models/member_model.dart';

class FamilyRepositoryImpl implements FamilyRepository {
  final FamilyRemoteDataSource remoteDataSource;

  FamilyRepositoryImpl({required this.remoteDataSource});

  // ─── Members ──────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<MemberEntity>>> getMembers(
      {int? branchId}) async {
    try {
      final models = await remoteDataSource.getMembers(branchId: branchId);
      // Return as Entity list (models are already entities via inheritance)
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

  // ─── Branches ─────────────────────────────────────────────────────────────

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

  // ---------- Family & Onboarding ----------

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
