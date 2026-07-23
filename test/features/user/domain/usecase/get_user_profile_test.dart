import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giatocviet/core/errors/failures.dart';
import 'package:giatocviet/core/usecases/usecase.dart';
import 'package:giatocviet/core/domain/entity/user_entity.dart';
import 'package:giatocviet/features/user/domain/repository/user_repository.dart';
import 'package:giatocviet/features/user/domain/usecase/get_user_profile.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late GetUserProfile usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = GetUserProfile(mockUserRepository);
  });

  const tUserEntity = UserEntity(
    id: 1,
    email: 'test@example.com',
    fullName: 'Nguyễn Văn A',
    role: 'MEMBER',
    familyId: 10,
  );

  test('nên trả về UserEntity khi gọi repository thành công', () async {
    // Arrange
    when(() => mockUserRepository.getUserProfile())
        .thenAnswer((_) async => const Right(tUserEntity));

    // Act
    final result = await usecase(NoParams());

    // Assert
    expect(result, const Right(tUserEntity));
    verify(() => mockUserRepository.getUserProfile()).called(1);
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('nên trả về ServerFailure khi repository thất bại', () async {
    // Arrange
    const tFailure = ServerFailure(message: 'Server Error');
    when(() => mockUserRepository.getUserProfile())
        .thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await usecase(NoParams());

    // Assert
    expect(result, const Left(tFailure));
    verify(() => mockUserRepository.getUserProfile()).called(1);
    verifyNoMoreInteractions(mockUserRepository);
  });
}
