import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/events_repository.dart';
import '../datasources/events_remote_data_source.dart';

class EventsRepositoryImpl implements EventsRepository {

  EventsRepositoryImpl({required this.remoteDataSource});
  final EventsRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<EventEntity>>> getEvents({required int familyId}) async {
    try {
      final events = await remoteDataSource.getEvents(familyId: familyId);
      return Right(events);
    } catch (e) {
      return Left(ErrorHandler.map(e));
    }
  }

  @override
  Future<Either<Failure, EventEntity>> saveEvent(EventEntity event) async {
    try {
      final saved = await remoteDataSource.saveEvent(event);
      return Right(saved);
    } catch (e) {
      return Left(ErrorHandler.map(e));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteEvent(int id) async {
    try {
      final success = await remoteDataSource.deleteEvent(id);
      return Right(success);
    } catch (e) {
      return Left(ErrorHandler.map(e));
    }
  }
}
