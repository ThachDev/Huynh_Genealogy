import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:app_family_tree/exception_handler/failures.dart';
import 'package:app_family_tree/base/usecase.dart';
import 'package:app_family_tree/features/family_tree/domain/entity/member_entity.dart';
import 'package:app_family_tree/features/family_tree/domain/repository/family_repository.dart';

class SaveMember implements UseCase<MemberEntity, SaveMemberParams> {
  final FamilyRepository repository;

  SaveMember(this.repository);

  @override
  Future<Either<Failure, MemberEntity>> call(SaveMemberParams params) {
    return repository.saveMember(params.member);
  }
}

class SaveMemberParams extends Equatable {
  final MemberEntity member;

  const SaveMemberParams({required this.member});

  @override
  List<Object?> get props => [member];
}






