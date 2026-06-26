import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:giatocviet/core/domain/entity/branch_entity.dart';
import '../repository/user_tree_repository.dart';

class UserGetBranches implements UseCase<List<BranchEntity>, NoParams> {
  final UserTreeRepository repository;

  UserGetBranches(this.repository);

  @override
  Future<Either<Failure, List<BranchEntity>>> call(NoParams params) {
    return repository.getBranches();
  }
}
