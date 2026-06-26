import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import '../repository/tree_repository.dart';

class GetMembers implements UseCase<List<MemberEntity>, GetMembersParams> {
  final TreeRepository repository;

  GetMembers(this.repository);

  @override
  Future<Either<Failure, List<MemberEntity>>> call(GetMembersParams params) {
    return repository.getMembers(branchId: params.branchId);
  }
}

class GetMembersParams extends Equatable {
  final int? branchId;

  const GetMembersParams({this.branchId});

  @override
  List<Object?> get props => [branchId];
}
