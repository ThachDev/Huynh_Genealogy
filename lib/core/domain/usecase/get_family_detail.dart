import 'package:dartz/dartz.dart';
import '../../errors/failures.dart';
import '../../usecases/usecase.dart';
import '../entity/family_entity.dart';
import '../../../features/onboarding/domain/repository/onboarding_repository.dart';

class GetFamilyDetail implements UseCase<FamilyEntity, int> {

  GetFamilyDetail(this.repository);
  final OnboardingRepository repository;

  @override
  Future<Either<Failure, FamilyEntity>> call(int familyId) {
    return repository.getFamilyDetail(familyId: familyId);
  }
}
