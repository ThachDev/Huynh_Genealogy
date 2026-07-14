import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/domain/entity/event_entity.dart';
import '../../../../core/domain/repository/events_repository.dart';

class SaveEvent implements UseCase<EventEntity, SaveEventParams> {
  final EventsRepository repository;

  SaveEvent(this.repository);

  @override
  Future<Either<Failure, EventEntity>> call(SaveEventParams params) {
    return repository.saveEvent(params.event);
  }
}

class SaveEventParams extends Equatable {
  final EventEntity event;

  const SaveEventParams({required this.event});

  @override
  List<Object?> get props => [event];
}
