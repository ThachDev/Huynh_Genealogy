import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giatocviet/core/domain/entity/user_entity.dart';
import 'package:giatocviet/core/errors/failures.dart';
import 'package:giatocviet/features/auth/domain/repository/auth_repository.dart';
import 'package:giatocviet/features/auth/domain/usecase/login_with_email.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginWithEmail usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = LoginWithEmail(mockAuthRepository);
  });

  const tEmail = 'user@giatoc.vn';
  const tPassword = 'password123';
  const tParams = LoginWithEmailParams(email: tEmail, password: tPassword);
  const tUser = UserEntity(
    id: 1,
    fullName: 'Huỳnh Văn A',
    email: tEmail,
  );

  test('nên trả về UserEntity khi đăng nhập bằng email thành công', () async {
    // Arrange
    when(() => mockAuthRepository.loginWithEmail(email: tEmail, password: tPassword))
        .thenAnswer((_) async => const Right(tUser));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, const Right(tUser));
    verify(() => mockAuthRepository.loginWithEmail(email: tEmail, password: tPassword)).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('nên trả về AuthFailure khi mật khẩu hoặc email không chính xác', () async {
    // Arrange
    const tFailure = AuthFailure(message: 'Mật khẩu không chính xác');
    when(() => mockAuthRepository.loginWithEmail(email: tEmail, password: tPassword))
        .thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, const Left(tFailure));
    verify(() => mockAuthRepository.loginWithEmail(email: tEmail, password: tPassword)).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
