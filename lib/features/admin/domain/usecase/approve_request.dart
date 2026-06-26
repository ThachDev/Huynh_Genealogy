import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../onboarding/domain/repository/onboarding_repository.dart';

class ApproveRequest implements UseCase<bool, int> {
  final OnboardingRepository repository;

  ApproveRequest(this.repository);

  @override
  Future<Either<Failure, bool>> call(int requestId) {
    return repository.approveRequest(requestId: requestId);
  }
}
