import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giatocviet/core/errors/exceptions.dart';
import 'package:giatocviet/core/errors/failures.dart';
import 'package:giatocviet/features/events/data/datasources/events_remote_data_source.dart';
import 'package:giatocviet/features/events/data/repositories/events_repository_impl.dart';
import 'package:giatocviet/features/events/domain/entities/event_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockEventsRemoteDataSource extends Mock implements EventsRemoteDataSource {}

void main() {
  late EventsRepositoryImpl repository;
  late MockEventsRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockEventsRemoteDataSource();
    repository = EventsRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  const tFamilyId = 1;
  final tEventsList = [
    const EventEntity(
      id: 1,
      title: 'Họp Mặt Đầu Năm',
      eventDate: '2026-01-01',
      familyId: tFamilyId,
    ),
  ];

  group('getEvents', () {
    test('nên trả về Right(List<EventEntity>) khi DataSource gọi thành công', () async {
      // Arrange
      when(() => mockRemoteDataSource.getEvents(familyId: tFamilyId))
          .thenAnswer((_) async => tEventsList);

      // Act
      final result = await repository.getEvents(familyId: tFamilyId);

      // Assert
      expect(result, Right(tEventsList));
      verify(() => mockRemoteDataSource.getEvents(familyId: tFamilyId)).called(1);
    });

    test('nên trả về Left(ServerFailure) khi DataSource quăng ra ServerException', () async {
      // Arrange
      when(() => mockRemoteDataSource.getEvents(familyId: tFamilyId))
          .thenThrow(const ServerException(message: 'Lỗi máy chủ 500'));

      // Act
      final result = await repository.getEvents(familyId: tFamilyId);

      // Assert
      expect(result, isA<Left<Failure, List<EventEntity>>>());
      result.fold(
        (failure) => expect(failure.message, equals('Lỗi máy chủ 500')),
        (_) => fail('Nên là Left'),
      );
      verify(() => mockRemoteDataSource.getEvents(familyId: tFamilyId)).called(1);
    });
  });
}
