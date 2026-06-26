import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/domain/entity/family_user_entity.dart';
import '../../../onboarding/domain/repository/onboarding_repository.dart';

class GetPendingRequests implements UseCase<List<FamilyUserEntity>, int> {
  final OnboardingRepository repository;

  GetPendingRequests(this.repository);

  @override
  Future<Either<Failure, List<FamilyUserEntity>>> call(int familyId) {
    return repository.getPendingRequests(familyId: familyId);
  }
}
