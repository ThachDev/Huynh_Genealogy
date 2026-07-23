import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giatocviet/core/errors/failures.dart';
import 'package:giatocviet/features/events/domain/entities/event_entity.dart';
import 'package:giatocviet/features/events/domain/usecases/delete_event.dart';
import 'package:giatocviet/features/events/domain/usecases/get_events.dart';
import 'package:giatocviet/features/events/domain/usecases/save_event.dart';
import 'package:giatocviet/features/events/presentation/bloc/events_bloc.dart';
import 'package:giatocviet/features/events/presentation/bloc/events_event.dart';
import 'package:giatocviet/features/events/presentation/bloc/events_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetEvents extends Mock implements GetEvents {}
class MockSaveEvent extends Mock implements SaveEvent {}
class MockDeleteEvent extends Mock implements DeleteEvent {}

void main() {
  late EventsBloc eventsBloc;
  late MockGetEvents mockGetEvents;
  late MockSaveEvent mockSaveEvent;
  late MockDeleteEvent mockDeleteEvent;

  setUpAll(() {
    registerFallbackValue(const GetEventsParams(familyId: 1));
  });

  setUp(() {
    mockGetEvents = MockGetEvents();
    mockSaveEvent = MockSaveEvent();
    mockDeleteEvent = MockDeleteEvent();

    eventsBloc = EventsBloc(
      getEvents: mockGetEvents,
      saveEvent: mockSaveEvent,
      deleteEvent: mockDeleteEvent,
    );
  });

  tearDown(() {
    eventsBloc.close();
  });

  const tFamilyId = 1;
  const tParams = GetEventsParams(familyId: tFamilyId);
  final tEventsList = [
    const EventEntity(
      id: 1,
      title: 'Lễ Độc Lập Gia Tộc',
      eventDate: '2026-09-02',
      familyId: tFamilyId,
    ),
  ];

  test('trạng thái ban đầu của BLoC phải là EventsInitial', () {
    expect(eventsBloc.state, isA<EventsInitial>());
  });

  test('nên emit [EventsLoading, EventsLoaded] khi LoadEventsEvent thành công', () async {
    // Arrange
    when(() => mockGetEvents(tParams))
        .thenAnswer((_) async => Right(tEventsList));

    // Assert Later
    final expectedStates = [
      isA<EventsLoading>(),
      isA<EventsLoaded>().having((s) => s.events, 'events', equals(tEventsList)),
    ];
    expectLater(eventsBloc.stream, emitsInOrder(expectedStates));

    // Act
    eventsBloc.add(const LoadEventsEvent(familyId: tFamilyId));
  });

  test('nếu LoadEventsEvent gặp lỗi thì emit [EventsLoading, EventsError]', () async {
    // Arrange
    when(() => mockGetEvents(tParams))
        .thenAnswer((_) async => const Left(ServerFailure(message: 'Lỗi tải sự kiện')));

    // Assert Later
    final expectedStates = [
      isA<EventsLoading>(),
      isA<EventsError>().having((s) => s.message, 'message', equals('Lỗi tải sự kiện')),
    ];
    expectLater(eventsBloc.stream, emitsInOrder(expectedStates));

    // Act
    eventsBloc.add(const LoadEventsEvent(familyId: tFamilyId));
  });
}
