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
    return repository.getMembers(branchId: params.branchId);
  }
}

class UserGetMembersParams extends Equatable {
  final int? branchId;

  const UserGetMembersParams({this.branchId});

  @override
  List<Object?> get props => [branchId];
}
