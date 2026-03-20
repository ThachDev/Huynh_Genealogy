import 'package:dartz/dartz.dart';
import 'package:app_family_tree/core/usecase/usecase.dart';
import 'package:app_family_tree/core/error/failures.dart';
import 'package:app_family_tree/features/branch/domain/entities/branch.dart';
import 'package:app_family_tree/features/branch/domain/repositories/branch_repository.dart';

class GetBranchesUseCase extends UseCase<List<BranchEntity>, NoParams> {
  final BranchRepository repository;

  GetBranchesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<BranchEntity>>> call(NoParams params) {
    return repository.getBranches();
  }
}
