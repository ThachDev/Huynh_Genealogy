import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:app_family_tree/exception_handler/failures.dart';
import 'package:app_family_tree/base/usecase.dart';
import 'package:app_family_tree/features/family_tree/domain/repository/family_repository.dart';

class DeleteMember implements UseCase<bool, DeleteMemberParams> {
  final FamilyRepository repository;

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






