import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import '../repository/family_tree_repository.dart';

class GetMembers implements UseCase<List<MemberEntity>, GetMembersParams> {
  final FamilyTreeRepository repository;

  GetMembers(this.repository);

  @override
  Future<Either<Failure, List<MemberEntity>>> call(GetMembersParams params) {
    return repository.getMembers(branchId: params.branchId, familyId: params.familyId);
  }
}

class GetMembersParams extends Equatable {
  final int? branchId;
  final int? familyId;

  const GetMembersParams({this.branchId, this.familyId});

  @override
  List<Object?> get props => [branchId, familyId];
}
