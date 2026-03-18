import 'package:dartz/dartz.dart';
import 'package:app_family_tree/core/usecase/usecase.dart';
import 'package:app_family_tree/core/error/failures.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/member.dart';
import 'package:app_family_tree/features/family_tree/domain/repositories/family_repository.dart';

class GetMemberByIdUseCase extends UseCase<MemberEntity, int> {
  final FamilyRepository repository;

  GetMemberByIdUseCase({required this.repository});

  @override
  Future<Either<Failure, MemberEntity>> call(int id) {
    return repository.getMemberById(id);
  }
}
