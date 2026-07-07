import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../family_tree/domain/repository/family_tree_repository.dart';

class DeleteMember implements UseCase<bool, DeleteMemberParams> {
  final FamilyTreeRepository repository;

  DeleteMember(this.repository);

  @override
  Future<Either<Failure, bool>> call(DeleteMemberParams params) {
    return repository.deleteMember(params.id);
  }
}

class DeleteMemberParams extends Equatable {
  final int id;

  const DeleteMemberParams({required this.id});

  @override
  List<Object?> get props => [id];
}
