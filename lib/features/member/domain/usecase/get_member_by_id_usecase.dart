import 'package:dartz/dartz.dart';
import 'package:app_family_tree/core/usecase/usecase.dart';
import 'package:app_family_tree/core/error/failures.dart';
import 'package:app_family_tree/features/member/domain/entities/member.dart';
import 'package:app_family_tree/features/member/domain/repositories/member_repository.dart';

class GetMemberByIdUseCase extends UseCase<MemberEntity, int> {
  final MemberRepository repository;

  GetMemberByIdUseCase({required this.repository});

  @override
  Future<Either<Failure, MemberEntity>> call(int id) {
    return repository.getMemberById(id);
  }
}
