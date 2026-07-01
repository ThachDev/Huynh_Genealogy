import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../onboarding/domain/repository/onboarding_repository.dart';

class RejectRequest implements UseCase<bool, int> {
  final OnboardingRepository repository;

  RejectRequest(this.repository);

  @override
  Future<Either<Failure, bool>> call(int requestId) {
    return repository.rejectRequest(requestId: requestId);
  }
}
