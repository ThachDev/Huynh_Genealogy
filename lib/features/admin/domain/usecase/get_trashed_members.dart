import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import '../../../family_tree/domain/repository/family_tree_repository.dart';

class GetTrashedMembers implements UseCase<List<MemberEntity>, GetTrashedMembersParams> {

  GetTrashedMembers(this.repository);
  final FamilyTreeRepository repository;

  @override
  Future<Either<Failure, List<MemberEntity>>> call(GetTrashedMembersParams params) {
    return repository.getTrashedMembers(familyId: params.familyId, branchId: params.branchId);
  }
}

class GetTrashedMembersParams extends Equatable {

  const GetTrashedMembersParams({this.familyId, this.branchId});
  final int? familyId;
  final int? branchId;

  @override
  List<Object?> get props => [familyId, branchId];
}
