import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/domain/entity/family_entity.dart';
import '../../../onboarding/domain/repository/onboarding_repository.dart';

class GetFamilyDetail implements UseCase<FamilyEntity, int> {
  final OnboardingRepository repository;

  GetFamilyDetail(this.repository);

  @override
  Future<Either<Failure, FamilyEntity>> call(int familyId) {
    return repository.getFamilyDetail(familyId: familyId);
  }
}
