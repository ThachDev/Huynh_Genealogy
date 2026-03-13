import 'package:dartz/dartz.dart';
import 'package:app_family_tree/base/usecase.dart';
import 'package:app_family_tree/exception_handler/failures.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/branch.dart';
import 'package:app_family_tree/features/family_tree/domain/repositories/family_repository.dart';

class SaveBranchUseCase extends UseCase<BranchEntity, BranchEntity> {
  final FamilyRepository repository;

  SaveBranchUseCase({required this.repository});

  @override
  Future<Either<Failure, BranchEntity>> call(BranchEntity branch) {
    return repository.saveBranch(branch);
  }
}
