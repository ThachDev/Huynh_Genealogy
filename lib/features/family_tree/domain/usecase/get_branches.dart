import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:giatocviet/core/domain/entity/branch_entity.dart';
import '../repository/family_tree_repository.dart';

class GetBranches implements UseCase<List<BranchEntity>, GetBranchesParams> {

  GetBranches(this.repository);
  final FamilyTreeRepository repository;

  @override
  Future<Either<Failure, List<BranchEntity>>> call(GetBranchesParams params) {
    return repository.getBranches(familyId: params.familyId);
  }
}

class GetBranchesParams extends Equatable {

  const GetBranchesParams({this.familyId});
  final int? familyId;

  @override
  List<Object?> get props => [familyId];
}
