import 'package:equatable/equatable.dart';
import '../../../../../core/domain/entity/event_entity.dart';

abstract class EventsState extends Equatable {
  const EventsState();

  @override
  List<Object?> get props => [];
}

class EventsInitial extends EventsState {}

class EventsLoading extends EventsState {}

class EventsLoaded extends EventsState {

  const EventsLoaded({required this.events});
  final List<EventEntity> events;

  @override
  List<Object?> get props => [events];
}

class EventsError extends EventsState {

  const EventsError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}

// Submitting actions (create/update/delete)
class EventsSubmitting extends EventsState {}

class EventsSubmitSuccess extends EventsState {

  const EventsSubmitSuccess({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
