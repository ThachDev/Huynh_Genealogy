import 'package:dartz/dartz.dart';
import 'package:app_family_tree/exception_handler/failures.dart';
import 'package:app_family_tree/features/family_tree/domain/entity/branch_entity.dart';
import 'package:app_family_tree/features/family_tree/domain/entity/member_entity.dart';

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
}






