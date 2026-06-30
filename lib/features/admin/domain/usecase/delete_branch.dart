import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../user/domain/repository/user_tree_repository.dart';

class DeleteBranch implements UseCase<bool, int> {
  final UserTreeRepository repository;

  DeleteBranch(this.repository);

  @override
  Future<Either<Failure, bool>> call(int id) {
    return repository.deleteBranch(id);
  }
}
