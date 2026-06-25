import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entity/branch_entity.dart';
import '../repository/tree_repository.dart';

class GetBranches implements UseCase<List<BranchEntity>, NoParams> {
  final TreeRepository repository;

  GetBranches(this.repository);

  @override
  Future<Either<Failure, List<BranchEntity>>> call(NoParams params) {
    return repository.getBranches();
  }
}
