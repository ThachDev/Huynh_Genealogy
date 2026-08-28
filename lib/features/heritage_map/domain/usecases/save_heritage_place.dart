import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/heritage_place_entity.dart';
import '../repositories/heritage_place_repository.dart';

class SaveHeritagePlaceParams {
  const SaveHeritagePlaceParams({required this.place});
  final HeritagePlaceEntity place;
}

class SaveHeritagePlace implements UseCase<HeritagePlaceEntity, SaveHeritagePlaceParams> {
  const SaveHeritagePlace(this.repository);
  final HeritagePlaceRepository repository;

  @override
  Future<Either<Failure, HeritagePlaceEntity>> call(SaveHeritagePlaceParams params) {
    return repository.saveHeritagePlace(place: params.place);
  }
}
