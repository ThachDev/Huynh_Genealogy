import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/member_entity.dart';
import '../repositories/family_repository.dart';

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
