import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:app_family_tree/exception_handler/failures.dart';
import 'package:app_family_tree/base/usecase.dart';
import 'package:app_family_tree/features/family_tree/domain/entity/member_entity.dart';
import 'package:app_family_tree/features/family_tree/domain/repository/family_repository.dart';

class GetMembers implements UseCase<List<MemberEntity>, GetMembersParams> {
  final FamilyRepository repository;

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






