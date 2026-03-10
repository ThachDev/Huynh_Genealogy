import 'package:dartz/dartz.dart';
import 'package:app_family_tree/exception_handler/failures.dart';
import 'package:app_family_tree/base/usecase.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/branch.dart';
import 'package:app_family_tree/features/family_tree/domain/repositories/family_repository.dart';

class GetBranches implements UseCase<List<BranchEntity>, NoParams> {
  final FamilyRepository repository;

  GetBranches(this.repository);

  @override
  Future<Either<Failure, List<BranchEntity>>> call(NoParams params) {
    return repository.getBranches();
  }
}
