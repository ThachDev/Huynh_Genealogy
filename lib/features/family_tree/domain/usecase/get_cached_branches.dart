import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:giatocviet/features/family_tree/domain/entities/branch_entity.dart';
import '../repository/family_tree_repository.dart';

class GetCachedBranches implements UseCase<List<BranchEntity>?, GetCachedBranchesParams> {

  GetCachedBranches(this.repository);
  final FamilyTreeRepository repository;

  @override
  Future<Either<Failure, List<BranchEntity>?>> call(GetCachedBranchesParams params) async {
    return Right(await repository.getCachedBranches(familyId: params.familyId));
  }
}

class GetCachedBranchesParams extends Equatable {

  const GetCachedBranchesParams({this.familyId});
  final int? familyId;

  @override
  List<Object?> get props => [familyId];
}
