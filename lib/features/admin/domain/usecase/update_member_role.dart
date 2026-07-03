import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../onboarding/domain/repository/onboarding_repository.dart';

class UpdateMemberRoleParams {
  final int familyId;
  final int userId;
  final String role;

  const UpdateMemberRoleParams({
    required this.familyId,
    required this.userId,
    required this.role,
  });
}

class UpdateMemberRole implements UseCase<bool, UpdateMemberRoleParams> {
  final OnboardingRepository repository;

  UpdateMemberRole(this.repository);

  @override
  Future<Either<Failure, bool>> call(UpdateMemberRoleParams params) {
    return repository.updateMemberRole(
      familyId: params.familyId,
      userId: params.userId,
      role: params.role,
    );
  }
}
