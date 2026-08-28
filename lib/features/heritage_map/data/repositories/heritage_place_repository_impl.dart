import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../datasources/heritage_place_remote_data_source.dart';
import '../models/heritage_place_model.dart';
import '../../domain/entities/heritage_place_entity.dart';
import '../../domain/repositories/heritage_place_repository.dart';

class HeritagePlaceRepositoryImpl implements HeritagePlaceRepository {
  HeritagePlaceRepositoryImpl({required this.remoteDataSource});
  final HeritagePlaceRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<HeritagePlaceEntity>>> getHeritagePlaces({
    required int familyId,
    HeritagePlaceType? type,
    int? generation,
    String? query,
  }) async {
    try {
      final models = await remoteDataSource.getHeritagePlaces(
        familyId: familyId,
        type: type?.toDbString(),
        generation: generation,
        query: query,
      );
      return Right(models.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, HeritagePlaceEntity>> getHeritagePlaceById({
    required int familyId,
    required int placeId,
  }) async {
    try {
      final model = await remoteDataSource.getHeritagePlaceById(
        familyId: familyId,
        placeId: placeId,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, HeritagePlaceEntity?>> getMemberGrave({
    required int familyId,
    required int memberId,
  }) async {
    try {
      final model = await remoteDataSource.getMemberGrave(
        familyId: familyId,
        memberId: memberId,
      );
      return Right(model?.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, HeritagePlaceEntity>> saveHeritagePlace({
    required HeritagePlaceEntity place,
  }) async {
    try {
      final model = HeritagePlaceModel.fromEntity(place);
      final saved = await remoteDataSource.saveHeritagePlace(model);
      return Right(saved.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteHeritagePlace({
    required int familyId,
    required int placeId,
  }) async {
    try {
      final result = await remoteDataSource.deleteHeritagePlace(
        familyId: familyId,
        placeId: placeId,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
