import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../family_tree/domain/entities/family_entity.dart';
import '../../../../core/domain/entity/family_user_entity.dart';

/// ============================================================================
/// REPOSITORY INTERFACE — ONBOARDING FEATURE (DOMAIN LAYER)
/// ============================================================================
/// Khai báo Hợp đồng (Contract) đại diện cho các nghiệp vụ dữ liệu Onboarding.
///
/// Theo nguyên lý Dependency Inversion trong Clean Architecture:
///   - Domain Layer định nghĩa Interface này mà KHÔNG quan tâm dữ liệu đến từ đâu
///     (REST API, SQLite hay Firebase).
///   - Data Layer chịu trách nhiệm triển khai (Implement) Interface này.
/// ============================================================================
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
    String? fullName,
    String? gender,
    String? dateOfBirth,
    String? placeOfBirth,
    String? maritalStatus,
    String? education,
    String? avatarUrl,
    int? parentId,
    int? spouseId,
    String? notes,
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

  Future<Either<Failure, bool>> deleteFamily({
    required int familyId,
  });

  Future<Either<Failure, bool>> linkMemberToUser({
    required int userId,
    required int memberId,
  });

  Future<Either<Failure, bool>> transferOwnership({
    required int familyId,
    required int newOwnerUserId,
  });
}
