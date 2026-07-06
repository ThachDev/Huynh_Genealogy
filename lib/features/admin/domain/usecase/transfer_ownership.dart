import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../onboarding/domain/repository/onboarding_repository.dart';

class TransferOwnershipParams {
  final int familyId;
  final int newOwnerUserId;

  const TransferOwnershipParams({
    required this.familyId,
    required this.newOwnerUserId,
  });
}

class TransferOwnership implements UseCase<bool, TransferOwnershipParams> {
  final OnboardingRepository repository;

  TransferOwnership(this.repository);

  @override
  Future<Either<Failure, bool>> call(TransferOwnershipParams params) {
    return repository.transferOwnership(
      familyId: params.familyId,
      newOwnerUserId: params.newOwnerUserId,
    );
  }
}
