import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/event_entity.dart';
import '../entities/event_interaction.dart';

abstract class EventsRepository {
  Future<Either<Failure, List<EventEntity>>> getEvents({required int familyId});
  Future<Either<Failure, EventEntity>> saveEvent(EventEntity event);
  Future<Either<Failure, bool>> deleteEvent(int id);

  Future<Either<Failure, Map<String, dynamic>>> reactToEvent(int eventId);
  Future<Either<Failure, List<EventInteractionModel>>> getComments(
    int eventId,
  );
  Future<Either<Failure, EventInteractionModel>> createComment(
    int eventId,
    String content,
  );
  Future<Either<Failure, bool>> markEventAsRead(int eventId);
  Future<Either<Failure, bool>> markAllEventsAsRead();
  Future<Either<Failure, bool>> dismissEvent(int eventId);
  Future<Either<Failure, bool>> dismissAllEvents();
}
