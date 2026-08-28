import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/heritage_place_entity.dart';
import '../repositories/heritage_place_repository.dart';

class GetMemberGraveParams {
  const GetMemberGraveParams({
    required this.familyId,
    required this.memberId,
  });

  final int familyId;
  final int memberId;
}

class GetMemberGrave implements UseCase<HeritagePlaceEntity?, GetMemberGraveParams> {
  const GetMemberGrave(this.repository);
  final HeritagePlaceRepository repository;

  @override
  Future<Either<Failure, HeritagePlaceEntity?>> call(GetMemberGraveParams params) {
    return repository.getMemberGrave(
      familyId: params.familyId,
      memberId: params.memberId,
    );
  }
}
