import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/domain/entity/branch_entity.dart';
import '../../../family_tree/domain/repository/family_tree_repository.dart';

class SaveBranch implements UseCase<BranchEntity, BranchEntity> {
  final FamilyTreeRepository repository;

  SaveBranch(this.repository);

  @override
  Future<Either<Failure, BranchEntity>> call(BranchEntity branch) {
    return repository.saveBranch(branch);
  }
}
