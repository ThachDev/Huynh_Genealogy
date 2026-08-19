import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import '../../../family_tree/domain/repository/family_tree_repository.dart';

class SaveMember implements UseCase<MemberEntity, SaveMemberParams> {

  SaveMember(this.repository);
  final FamilyTreeRepository repository;

  @override
  Future<Either<Failure, MemberEntity>> call(SaveMemberParams params) {
    return repository.saveMember(params.member);
  }
}

class SaveMemberParams extends Equatable {

  const SaveMemberParams({required this.member});
  final MemberEntity member;

  @override
  List<Object?> get props => [member];
}
