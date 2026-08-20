import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/entities/event_interaction.dart';
import '../../domain/repositories/events_repository.dart';
import '../datasources/event_api_service.dart';
import '../datasources/events_remote_data_source.dart';

class EventsRepositoryImpl implements EventsRepository {

  EventsRepositoryImpl({
    required this.remoteDataSource,
    required this.eventApiService,
  });
  final EventsRemoteDataSource remoteDataSource;
  final EventApiService eventApiService;

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

  @override
  Future<Either<Failure, Map<String, dynamic>>> reactToEvent(int eventId) async {
    try {
      final result = await eventApiService.reactToEvent(eventId);
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.map(e));
    }
  }

  @override
  Future<Either<Failure, List<EventInteractionModel>>> getComments(
    int eventId,
  ) async {
    try {
      final comments = await eventApiService.getComments(eventId);
      return Right(comments);
    } catch (e) {
      return Left(ErrorHandler.map(e));
    }
  }

  @override
  Future<Either<Failure, EventInteractionModel>> createComment(
    int eventId,
    String content,
  ) async {
    try {
      final comment = await eventApiService.createComment(eventId, content);
      return Right(comment);
    } catch (e) {
      return Left(ErrorHandler.map(e));
    }
  }

  @override
  Future<Either<Failure, bool>> markEventAsRead(int eventId) async {
    try {
      final success = await eventApiService.markEventAsRead(eventId);
      return Right(success);
    } catch (e) {
      return Left(ErrorHandler.map(e));
    }
  }

  @override
  Future<Either<Failure, bool>> markAllEventsAsRead() async {
    try {
      final success = await eventApiService.markAllEventsAsRead();
      return Right(success);
    } catch (e) {
      return Left(ErrorHandler.map(e));
    }
  }

  @override
  Future<Either<Failure, bool>> dismissEvent(int eventId) async {
    try {
      final success = await eventApiService.dismissEvent(eventId);
      return Right(success);
    } catch (e) {
      return Left(ErrorHandler.map(e));
    }
  }

  @override
  Future<Either<Failure, bool>> dismissAllEvents() async {
    try {
      final success = await eventApiService.dismissAllEvents();
      return Right(success);
    } catch (e) {
      return Left(ErrorHandler.map(e));
    }
  }
}
