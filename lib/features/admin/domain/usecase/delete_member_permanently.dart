import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../family_tree/domain/repository/family_tree_repository.dart';

class DeleteMemberPermanently implements UseCase<bool, int> {
  DeleteMemberPermanently(this.repository);
  final FamilyTreeRepository repository;

  @override
  Future<Either<Failure, bool>> call(int id) {
    return repository.deleteMemberPermanently(id);
  }
}
