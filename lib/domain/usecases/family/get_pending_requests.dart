import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/family_user_entity.dart';
import '../../repositories/family_repository.dart';

class GetPendingRequests implements UseCase<List<FamilyUserEntity>, int> {
  final FamilyRepository repository;

  GetPendingRequests(this.repository);

  @override
  Future<Either<Failure, List<FamilyUserEntity>>> call(int familyId) {
    return repository.getPendingRequests(familyId: familyId);
  }
}
