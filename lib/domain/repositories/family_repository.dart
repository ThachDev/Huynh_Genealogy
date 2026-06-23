import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/branch_entity.dart';
import '../entities/member_entity.dart';
import '../entities/family_entity.dart';
import '../entities/family_user_entity.dart';

/// Abstract interface – chỉ định nghĩa "cần làm gì",
/// không quan tâm "làm bằng cách nào" (HTTP, SQLite, ...)
abstract class FamilyRepository {
  // ---------- Members ----------
  Future<Either<Failure, List<MemberEntity>>> getMembers({int? branchId});
  Future<Either<Failure, MemberEntity>> getMemberById(int id);
  Future<Either<Failure, MemberEntity>> saveMember(MemberEntity member);
  Future<Either<Failure, bool>> deleteMember(int id);

  // ---------- Branches ----------
  Future<Either<Failure, List<BranchEntity>>> getBranches();
  Future<Either<Failure, BranchEntity>> getBranchById(int id);
  Future<Either<Failure, BranchEntity>> saveBranch(BranchEntity branch);
  Future<Either<Failure, bool>> deleteBranch(int id);

  // ---------- Family & Onboarding ----------
  Future<Either<Failure, FamilyEntity>> createFamily({
    required String name,
    String? description,
    String? coverImageUrl,
    required int userId,
  });

  Future<Either<Failure, Map<String, dynamic>>> verifyInviteCode({
    required String code,
  });

  Future<Either<Failure, FamilyUserEntity>> joinFamily({
    required int userId,
    required int familyId,
    int? memberNodeId,
  });

  Future<Either<Failure, List<FamilyUserEntity>>> getPendingRequests({
    required int familyId,
  });

  Future<Either<Failure, bool>> approveRequest({
    required int requestId,
  });
}
