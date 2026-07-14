import 'package:equatable/equatable.dart';
import '../../domain/entity/event_entity.dart';

abstract class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object?> get props => [];
}

class LoadEventsEvent extends EventsEvent {
  final int familyId;

  const LoadEventsEvent({required this.familyId});

  @override
  List<Object?> get props => [familyId];
}

class SaveEventEvent extends EventsEvent {
  final EventEntity event;

  const SaveEventEvent({required this.event});

  @override
  List<Object?> get props => [event];
}

class DeleteEventEvent extends EventsEvent {
  final int id;
  final int familyId;

  const DeleteEventEvent({required this.id, required this.familyId});

  @override
  List<Object?> get props => [id, familyId];
}
