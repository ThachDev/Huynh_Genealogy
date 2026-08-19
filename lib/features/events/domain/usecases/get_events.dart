import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/event_entity.dart';
import '../repositories/events_repository.dart';

class GetEvents implements UseCase<List<EventEntity>, GetEventsParams> {

  GetEvents(this.repository);
  final EventsRepository repository;

  @override
  Future<Either<Failure, List<EventEntity>>> call(GetEventsParams params) {
    return repository.getEvents(familyId: params.familyId);
  }
}

class GetEventsParams extends Equatable {

  const GetEventsParams({required this.familyId});
  final int familyId;

  @override
  List<Object?> get props => [familyId];
}
