import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/domain/entity/family_entity.dart';
import '../../../../core/domain/entity/family_user_entity.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, FamilyEntity>> createFamily({
    required String name,
    String? description,
    String? logoUrl,
    required int userId,
  });

  Future<Either<Failure, Map<String, dynamic>>> verifyInviteCode({
    required String code,
  });

  Future<Either<Failure, FamilyUserEntity>> joinFamily({
    required int userId,
    required int familyId,
    int? memberNodeId,
  });

  Future<Either<Failure, List<FamilyUserEntity>>> getPendingRequests({
    required int familyId,
  });

  Future<Either<Failure, bool>> approveRequest({
    required int requestId,
  });

  Future<Either<Failure, bool>> rejectRequest({
    required int requestId,
  });

  Future<Either<Failure, FamilyEntity>> getFamilyDetail({
    required int familyId,
  });

  Future<Either<Failure, FamilyEntity>> updateFamily({
    required int id,
    String? name,
    String? description,
    String? origin,
    String? logoUrl,
  });

  Future<Either<Failure, List<FamilyUserEntity>>> getApprovedMembers({
    required int familyId,
  });

  Future<Either<Failure, bool>> updateMemberRole({
    required int familyId,
    required int userId,
    required String role,
  });

  Future<Either<Failure, bool>> linkMemberToUser({
    required int userId,
    required int memberId,
  });
}
