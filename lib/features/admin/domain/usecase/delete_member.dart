import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../family_tree/domain/repository/family_tree_repository.dart';

class DeleteMember implements UseCase<bool, DeleteMemberParams> {

  DeleteMember(this.repository);
  final FamilyTreeRepository repository;

  @override
  Future<Either<Failure, bool>> call(DeleteMemberParams params) {
    return repository.deleteMember(params.id, reassignChildrenToParent: params.reassignChildrenToParent);
  }
}

class DeleteMemberParams extends Equatable {

  const DeleteMemberParams({
    required this.id,
    this.reassignChildrenToParent = false,
  });
  final int id;
  final bool reassignChildrenToParent;

  @override
  List<Object?> get props => [id, reassignChildrenToParent];
}
