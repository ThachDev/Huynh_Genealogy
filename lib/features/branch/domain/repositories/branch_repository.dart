import 'package:dartz/dartz.dart';
import 'package:app_family_tree/core/error/failures.dart';
import 'package:app_family_tree/features/branch/domain/entities/branch.dart';

abstract class BranchRepository {
  Future<Either<Failure, List<BranchEntity>>> getBranches();
  Future<Either<Failure, BranchEntity>> getBranchById(int id);
  Future<Either<Failure, BranchEntity>> saveBranch(BranchEntity branch);
  Future<Either<Failure, bool>> deleteBranch(int id);
}
