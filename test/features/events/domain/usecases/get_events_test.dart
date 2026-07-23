import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giatocviet/core/errors/failures.dart';
import 'package:giatocviet/features/events/domain/entities/event_entity.dart';
import 'package:giatocviet/features/events/domain/repositories/events_repository.dart';
import 'package:giatocviet/features/events/domain/usecases/get_events.dart';
import 'package:mocktail/mocktail.dart';

class MockEventsRepository extends Mock implements EventsRepository {}

void main() {
  late GetEvents usecase;
  late MockEventsRepository mockRepository;

  setUp(() {
    mockRepository = MockEventsRepository();
    usecase = GetEvents(mockRepository);
  });

  const tFamilyId = 1;
  const tParams = GetEventsParams(familyId: tFamilyId);
  final tEventsList = [
    const EventEntity(
      id: 101,
      title: 'Lễ Giỗ Tổ Họ Huỳnh',
      eventDate: '2026-08-15',
      familyId: tFamilyId,
    ),
  ];

  test('nên trả về danh sách EventEntity từ repository khi gọi thành công', () async {
    // Arrange
    when(() => mockRepository.getEvents(familyId: tFamilyId))
        .thenAnswer((_) async => Right(tEventsList));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, Right(tEventsList));
    verify(() => mockRepository.getEvents(familyId: tFamilyId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('nên trả về ServerFailure khi repository gặp lỗi server', () async {
    // Arrange
    const tFailure = ServerFailure(message: 'Lỗi máy chủ');
    when(() => mockRepository.getEvents(familyId: tFamilyId))
        .thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, const Left(tFailure));
    verify(() => mockRepository.getEvents(familyId: tFamilyId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
