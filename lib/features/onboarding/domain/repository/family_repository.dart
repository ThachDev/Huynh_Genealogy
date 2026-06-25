import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entity/family_entity.dart';
import '../entity/family_user_entity.dart';

abstract class FamilyRepository {
  Future<Either<Failure, FamilyEntity>> createFamily({
    required String name,
    String? description,
    String? coverImageUrl,
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
}
