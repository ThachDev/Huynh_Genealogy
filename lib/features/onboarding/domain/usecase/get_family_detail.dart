import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../family_tree/domain/entities/family_entity.dart';
import '../repository/onboarding_repository.dart';

class GetFamilyDetail implements UseCase<FamilyEntity, int> {

  GetFamilyDetail(this.repository);
  final OnboardingRepository repository;

  @override
  Future<Either<Failure, FamilyEntity>> call(int familyId) {
    return repository.getFamilyDetail(familyId: familyId);
  }
}
