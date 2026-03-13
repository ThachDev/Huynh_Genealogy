import 'package:dartz/dartz.dart';
import 'package:app_family_tree/base/usecase.dart';
import 'package:app_family_tree/exception_handler/failures.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/member.dart';
import 'package:app_family_tree/features/family_tree/domain/repositories/family_repository.dart';

class SaveMemberUseCase extends UseCase<MemberEntity, MemberEntity> {
  final FamilyRepository repository;

  SaveMemberUseCase({required this.repository});

  @override
  Future<Either<Failure, MemberEntity>> call(MemberEntity member) {
    return repository.saveMember(member);
  }
}
