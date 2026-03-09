import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/member_entity.dart';
import '../repositories/family_repository.dart';

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
