import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import 'package:giatocviet/core/domain/entity/branch_entity.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';

abstract class TreeRepository {
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
