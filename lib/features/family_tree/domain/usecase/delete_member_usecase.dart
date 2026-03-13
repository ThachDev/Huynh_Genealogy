import 'package:dartz/dartz.dart';
import 'package:app_family_tree/base/usecase.dart';
import 'package:app_family_tree/exception_handler/failures.dart';
import 'package:app_family_tree/features/family_tree/domain/repositories/family_repository.dart';

class DeleteMemberUseCase extends UseCase<bool, int> {
  final FamilyRepository repository;

  DeleteMemberUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(int id) {
    return repository.deleteMember(id);
  }
}
