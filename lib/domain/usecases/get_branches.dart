import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/branch_entity.dart';
import '../repositories/family_repository.dart';

class GetBranches implements UseCase<List<BranchEntity>, NoParams> {
  final FamilyRepository repository;

  GetBranches(this.repository);

  @override
  Future<Either<Failure, List<BranchEntity>>> call(NoParams params) {
    return repository.getBranches();
  }
}
