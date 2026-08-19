import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../onboarding/domain/repository/onboarding_repository.dart';

class UpdateMemberRoleParams {

  const UpdateMemberRoleParams({
    required this.familyId,
    required this.userId,
    required this.role,
  });
  final int familyId;
  final int userId;
  final String role;
}

class UpdateMemberRole implements UseCase<bool, UpdateMemberRoleParams> {

  UpdateMemberRole(this.repository);
  final OnboardingRepository repository;

  @override
  Future<Either<Failure, bool>> call(UpdateMemberRoleParams params) {
    return repository.updateMemberRole(
      familyId: params.familyId,
      userId: params.userId,
      role: params.role,
    );
  }
}
