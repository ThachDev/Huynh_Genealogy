import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/heritage_place_entity.dart';

abstract class HeritagePlaceRepository {
  Future<Either<Failure, List<HeritagePlaceEntity>>> getHeritagePlaces({
    required int familyId,
    HeritagePlaceType? type,
    int? generation,
    String? query,
  });

  Future<Either<Failure, HeritagePlaceEntity>> getHeritagePlaceById({
    required int familyId,
    required int placeId,
  });

  Future<Either<Failure, HeritagePlaceEntity?>> getMemberGrave({
    required int familyId,
    required int memberId,
  });

  Future<Either<Failure, HeritagePlaceEntity>> saveHeritagePlace({
    required HeritagePlaceEntity place,
  });

  Future<Either<Failure, bool>> deleteHeritagePlace({
    required int familyId,
    required int placeId,
  });
}
