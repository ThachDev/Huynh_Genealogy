import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../family_tree/domain/repository/family_tree_repository.dart';

class DeleteBranch implements UseCase<bool, int> {
  final FamilyTreeRepository repository;

  DeleteBranch(this.repository);

  @override
  Future<Either<Failure, bool>> call(int id) {
    return repository.deleteBranch(id);
  }
}
