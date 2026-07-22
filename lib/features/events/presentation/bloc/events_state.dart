import 'package:equatable/equatable.dart';
import '../../domain/entities/event_entity.dart';

abstract class EventsState extends Equatable {
  const EventsState();

  @override
  List<Object?> get props => [];
}

class EventsInitial extends EventsState {}

class EventsLoading extends EventsState {}

class EventsLoaded extends EventsState {
  final List<EventEntity> events;

  const EventsLoaded({required this.events});

  @override
  List<Object?> get props => [events];
}

class EventsError extends EventsState {
  final String message;

  const EventsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class EventsSubmitting extends EventsState {}

class EventsSubmitSuccess extends EventsState {
  final String message;

  const EventsSubmitSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}
