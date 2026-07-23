import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giatocviet/core/domain/entity/family_entity.dart';
import 'package:giatocviet/features/onboarding/domain/repository/onboarding_repository.dart';
import 'package:giatocviet/features/onboarding/domain/usecase/create_family.dart';
import 'package:mocktail/mocktail.dart';

class MockOnboardingRepository extends Mock implements OnboardingRepository {}

void main() {
  late CreateFamily usecase;
  late MockOnboardingRepository mockRepository;

  setUp(() {
    mockRepository = MockOnboardingRepository();
    usecase = CreateFamily(mockRepository);
  });

  const tName = 'Dòng Họ Huỳnh Võ';
  const tUserId = 1;
  const tParams = CreateFamilyParams(name: tName, userId: tUserId);
  const tFamily = FamilyEntity(id: 10, name: tName, inviteCode: 'GT123', creatorId: tUserId);

  test('nên trả về FamilyEntity khi tạo dòng họ mới thành công', () async {
    // Arrange
    when(() => mockRepository.createFamily(
          name: tName,
          description: null,
          logoUrl: null,
          userId: tUserId,
        )).thenAnswer((_) async => const Right(tFamily));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, const Right(tFamily));
    verify(() => mockRepository.createFamily(
          name: tName,
          description: null,
          logoUrl: null,
          userId: tUserId,
        )).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
