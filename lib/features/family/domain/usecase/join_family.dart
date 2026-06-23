import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entity/family_user_entity.dart';
import '../repository/family_repository.dart';

class JoinFamily implements UseCase<FamilyUserEntity, JoinFamilyParams> {
  final FamilyRepository repository;

  JoinFamily(this.repository);

  @override
  Future<Either<Failure, FamilyUserEntity>> call(JoinFamilyParams params) {
    return repository.joinFamily(
      userId: params.userId,
      familyId: params.familyId,
      memberNodeId: params.memberNodeId,
    );
  }
}

class JoinFamilyParams extends Equatable {
  final int userId;
  final int familyId;
  final int? memberNodeId;

  const JoinFamilyParams({
    required this.userId,
    required this.familyId,
    this.memberNodeId,
  });

  @override
  List<Object?> get props => [userId, familyId, memberNodeId];
}
