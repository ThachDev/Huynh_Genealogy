import 'package:dartz/dartz.dart';
import 'package:app_family_tree/core/usecase/usecase.dart';
import 'package:app_family_tree/core/error/failures.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/branch.dart';
import 'package:app_family_tree/features/family_tree/domain/repositories/family_repository.dart';

class GetBranchesUseCase extends UseCase<List<BranchEntity>, NoParams> {
  final FamilyRepository repository;

  GetBranchesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<BranchEntity>>> call(NoParams params) {
    return repository.getBranches();
  }
}
