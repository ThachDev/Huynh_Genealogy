import 'package:dartz/dartz.dart';
import 'package:app_family_tree/core/usecase/usecase.dart';
import 'package:app_family_tree/core/error/failures.dart';
import 'package:app_family_tree/features/branch/domain/entities/branch.dart';
import 'package:app_family_tree/features/branch/domain/repositories/branch_repository.dart';

class SaveBranchUseCase extends UseCase<BranchEntity, BranchEntity> {
  final BranchRepository repository;

  SaveBranchUseCase({required this.repository});

  @override
  Future<Either<Failure, BranchEntity>> call(BranchEntity branch) {
    return repository.saveBranch(branch);
  }
}
