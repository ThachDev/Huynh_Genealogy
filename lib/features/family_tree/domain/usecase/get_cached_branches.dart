import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:giatocviet/core/domain/entity/branch_entity.dart';
import '../repository/family_tree_repository.dart';

class GetCachedBranches implements UseCase<List<BranchEntity>?, GetCachedBranchesParams> {
  final FamilyTreeRepository repository;

  GetCachedBranches(this.repository);

  @override
  Future<Either<Failure, List<BranchEntity>?>> call(GetCachedBranchesParams params) async {
    return Right(await repository.getCachedBranches(familyId: params.familyId));
  }
}

class GetCachedBranchesParams extends Equatable {
  final int? familyId;

  const GetCachedBranchesParams({this.familyId});

  @override
  List<Object?> get props => [familyId];
}
