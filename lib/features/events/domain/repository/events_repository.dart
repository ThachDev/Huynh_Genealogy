import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entity/event_entity.dart';

abstract class EventsRepository {
  Future<Either<Failure, List<EventEntity>>> getEvents({required int familyId});
  Future<Either<Failure, EventEntity>> saveEvent(EventEntity event);
  Future<Either<Failure, bool>> deleteEvent(int id);
}
