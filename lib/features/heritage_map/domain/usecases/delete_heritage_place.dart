import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/heritage_place_repository.dart';

class DeleteHeritagePlaceParams {
  const DeleteHeritagePlaceParams({
    required this.familyId,
    required this.placeId,
  });
  final int familyId;
  final int placeId;
}

class DeleteHeritagePlace implements UseCase<bool, DeleteHeritagePlaceParams> {
  const DeleteHeritagePlace(this.repository);
  final HeritagePlaceRepository repository;

  @override
  Future<Either<Failure, bool>> call(DeleteHeritagePlaceParams params) {
    return repository.deleteHeritagePlace(
      familyId: params.familyId,
      placeId: params.placeId,
    );
  }
}
