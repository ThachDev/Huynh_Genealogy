import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecase/delete_event.dart';
import '../../../../../core/domain/usecase/get_events.dart';
import '../../../domain/usecase/save_event.dart';
import 'events_event.dart';
import 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final GetEvents getEvents;
  final SaveEvent saveEvent;
  final DeleteEvent deleteEvent;

  EventsBloc({
    required this.getEvents,
    required this.saveEvent,
    required this.deleteEvent,
  }) : super(EventsInitial()) {
    on<LoadEventsEvent>(_onLoadEvents);
    on<SaveEventEvent>(_onSaveEvent);
    on<DeleteEventEvent>(_onDeleteEvent);
  }

  Future<void> _onLoadEvents(LoadEventsEvent event, Emitter<EventsState> emit) async {
    emit(EventsLoading());
    final result = await getEvents(GetEventsParams(familyId: event.familyId));
    result.fold(
      (failure) => emit(EventsError(message: failure.message)),
      (events) => emit(EventsLoaded(events: events)),
    );
  }

  Future<void> _onSaveEvent(SaveEventEvent event, Emitter<EventsState> emit) async {
    emit(EventsSubmitting());
    final result = await saveEvent(SaveEventParams(event: event.event));
    result.fold(
      (failure) => emit(EventsError(message: failure.message)),
      (savedEvent) => emit(const EventsSubmitSuccess(message: 'Lưu sự kiện thành công')),
    );
  }

  Future<void> _onDeleteEvent(DeleteEventEvent event, Emitter<EventsState> emit) async {
    emit(EventsSubmitting());
    final result = await deleteEvent(DeleteEventParams(id: event.id));
    result.fold(
      (failure) => emit(EventsError(message: failure.message)),
      (success) => emit(const EventsSubmitSuccess(message: 'Xoá sự kiện thành công')),
    );
  }
}
