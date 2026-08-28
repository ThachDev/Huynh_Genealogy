import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/heritage_place_entity.dart';
import '../repositories/heritage_place_repository.dart';

class GetHeritagePlacesParams {
  const GetHeritagePlacesParams({
    required this.familyId,
    this.type,
    this.generation,
    this.query,
  });

  final int familyId;
  final HeritagePlaceType? type;
  final int? generation;
  final String? query;
}

class GetHeritagePlaces implements UseCase<List<HeritagePlaceEntity>, GetHeritagePlacesParams> {
  const GetHeritagePlaces(this.repository);
  final HeritagePlaceRepository repository;

  @override
  Future<Either<Failure, List<HeritagePlaceEntity>>> call(GetHeritagePlacesParams params) {
    return repository.getHeritagePlaces(
      familyId: params.familyId,
      type: params.type,
      generation: params.generation,
      query: params.query,
    );
  }
}
