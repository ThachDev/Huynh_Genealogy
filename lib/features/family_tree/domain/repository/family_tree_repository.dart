import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import 'package:giatocviet/features/family_tree/domain/entities/branch_entity.dart';
import 'package:giatocviet/features/family_tree/domain/entities/member_entity.dart';
import 'package:giatocviet/features/family_tree/domain/entities/audit_log_entity.dart';

abstract class FamilyTreeRepository {
  // ---------- Members ----------
  Future<Either<Failure, List<MemberEntity>>> getMembers({int? branchId, int? familyId});
  Future<List<MemberEntity>?> getCachedMembers({int? familyId});
  Future<Either<Failure, MemberEntity>> getMemberById(int id);
  Future<Either<Failure, MemberEntity>> saveMember(MemberEntity member);
  Future<Either<Failure, bool>> deleteMember(int id, {bool reassignChildrenToParent = false});
  Future<Either<Failure, List<MemberEntity>>> getTrashedMembers({int? familyId, int? branchId});
  Future<Either<Failure, MemberEntity>> restoreMember(int id);
  Future<Either<Failure, bool>> deleteMemberPermanently(int id);
  Future<Either<Failure, int>> purgeTrash({int days = 0});
  Future<Either<Failure, List<AuditLogEntity>>> getAuditLogs({int? familyId, int? limit});

  // ---------- Branches ----------
  Future<Either<Failure, List<BranchEntity>>> getBranches({int? familyId});
  Future<List<BranchEntity>?> getCachedBranches({int? familyId});
  Future<Either<Failure, BranchEntity>> getBranchById(int id);
  Future<Either<Failure, BranchEntity>> saveBranch(BranchEntity branch);
  Future<Either<Failure, bool>> deleteBranch(int id);
}
