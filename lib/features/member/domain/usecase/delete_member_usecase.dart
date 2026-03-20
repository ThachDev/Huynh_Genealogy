import 'package:dartz/dartz.dart';
import 'package:app_family_tree/core/usecase/usecase.dart';
import 'package:app_family_tree/core/error/failures.dart';
import 'package:app_family_tree/features/member/domain/repositories/member_repository.dart';

class DeleteMemberUseCase extends UseCase<bool, int> {
  final MemberRepository repository;

  DeleteMemberUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(int id) {
    return repository.deleteMember(id);
  }
}
