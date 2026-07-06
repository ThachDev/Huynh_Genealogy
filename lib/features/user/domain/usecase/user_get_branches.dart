import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:giatocviet/core/domain/entity/branch_entity.dart';
import '../repository/user_tree_repository.dart';

class UserGetBranches implements UseCase<List<BranchEntity>, UserGetBranchesParams> {
  final UserTreeRepository repository;

  UserGetBranches(this.repository);

  @override
  Future<Either<Failure, List<BranchEntity>>> call(UserGetBranchesParams params) {
    return repository.getBranches(familyId: params.familyId);
  }
}

class UserGetBranchesParams extends Equatable {
  final int? familyId;

  const UserGetBranchesParams({this.familyId});

  @override
  List<Object?> get props => [familyId];
}
