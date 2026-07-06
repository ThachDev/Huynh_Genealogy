import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import '../repository/user_tree_repository.dart';

class UserGetMembers implements UseCase<List<MemberEntity>, UserGetMembersParams> {
  final UserTreeRepository repository;

  UserGetMembers(this.repository);

  @override
  Future<Either<Failure, List<MemberEntity>>> call(UserGetMembersParams params) {
    return repository.getMembers(branchId: params.branchId, familyId: params.familyId);
  }
}

class UserGetMembersParams extends Equatable {
  final int? branchId;
  final int? familyId;

  const UserGetMembersParams({this.branchId, this.familyId});

  @override
  List<Object?> get props => [branchId, familyId];
}
