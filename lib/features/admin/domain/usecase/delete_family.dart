import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../onboarding/domain/repository/onboarding_repository.dart';

class DeleteFamily implements UseCase<bool, int> {

  DeleteFamily(this.repository);
  final OnboardingRepository repository;

  @override
  Future<Either<Failure, bool>> call(int familyId) {
    return repository.deleteFamily(familyId: familyId);
  }
}
