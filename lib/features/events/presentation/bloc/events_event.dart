import 'package:equatable/equatable.dart';
import '../../domain/entities/event_entity.dart';

abstract class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object?> get props => [];
}

class LoadEventsEvent extends EventsEvent {

  const LoadEventsEvent({required this.familyId});
  final int familyId;

  @override
  List<Object?> get props => [familyId];
}

class SaveEventEvent extends EventsEvent {

  const SaveEventEvent({required this.event});
  final EventEntity event;

  @override
  List<Object?> get props => [event];
}

class DeleteEventEvent extends EventsEvent {

  const DeleteEventEvent({required this.id, required this.familyId});
  final int id;
  final int familyId;

  @override
  List<Object?> get props => [id, familyId];
}
