import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giatocviet/core/errors/exceptions.dart';
import 'package:giatocviet/core/errors/failures.dart';
import 'package:giatocviet/core/domain/entity/user_entity.dart';
import 'package:giatocviet/features/user/data/repository/user_repository_impl.dart';
import 'package:giatocviet/features/user/data/source/user_remote_data_source.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRemoteDataSource extends Mock implements UserRemoteDataSource {}

void main() {
  late UserRepositoryImpl repository;
  late MockUserRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockUserRemoteDataSource();
    repository = UserRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  const tUserEntity = UserEntity(
    id: 1,
    email: 'user@example.com',
    fullName: 'Trần Văn B',
    role: 'OWNER',
    familyId: 5,
  );

  group('getUserProfile', () {
    test('nên trả về Right(UserEntity) khi gọi datasource thành công', () async {
      // Arrange
      when(() => mockRemoteDataSource.getUserProfile())
          .thenAnswer((_) async => tUserEntity);

      // Act
      final result = await repository.getUserProfile();

      // Assert
      expect(result, const Right(tUserEntity));
      verify(() => mockRemoteDataSource.getUserProfile()).called(1);
    });

    test('nếu có ServerException từ datasource thì trả về Left(ServerFailure)', () async {
      // Arrange
      when(() => mockRemoteDataSource.getUserProfile())
          .thenThrow(const ServerException(message: 'Lỗi máy chủ', statusCode: 500));

      // Act
      final result = await repository.getUserProfile();

      // Assert
      expect(result, isA<Left<Failure, UserEntity>>());
      verify(() => mockRemoteDataSource.getUserProfile()).called(1);
    });
  });
}
