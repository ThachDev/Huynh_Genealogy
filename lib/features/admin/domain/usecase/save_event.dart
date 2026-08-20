import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../events/domain/entities/event_entity.dart';
import '../../../events/domain/repositories/events_repository.dart';

class SaveEvent implements UseCase<EventEntity, SaveEventParams> {

  SaveEvent(this.repository);
  final EventsRepository repository;

  @override
  Future<Either<Failure, EventEntity>> call(SaveEventParams params) {
    return repository.saveEvent(params.event);
  }
}

class SaveEventParams extends Equatable {

  const SaveEventParams({required this.event});
  final EventEntity event;

  @override
  List<Object?> get props => [event];
}
