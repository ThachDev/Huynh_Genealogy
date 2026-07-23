import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giatocviet/core/domain/entity/branch_entity.dart';
import 'package:giatocviet/core/errors/failures.dart';
import 'package:giatocviet/features/family_tree/domain/repository/family_tree_repository.dart';
import 'package:giatocviet/features/family_tree/domain/usecase/get_branches.dart';
import 'package:mocktail/mocktail.dart';

class MockFamilyTreeRepository extends Mock implements FamilyTreeRepository {}

void main() {
  late GetBranches usecase;
  late MockFamilyTreeRepository mockRepository;

  setUp(() {
    mockRepository = MockFamilyTreeRepository();
    usecase = GetBranches(mockRepository);
  });

  const tFamilyId = 1;
  const tParams = GetBranchesParams(familyId: tFamilyId);
  final tBranchesList = [
    const BranchEntity(
      id: 10,
      name: 'Chi Nhánh Miền Nam',
      familyId: tFamilyId,
    ),
  ];

  test('nên trả về danh sách BranchEntity khi repository gọi thành công', () async {
    // Arrange
    when(() => mockRepository.getBranches(familyId: tFamilyId))
        .thenAnswer((_) async => Right(tBranchesList));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, Right(tBranchesList));
    verify(() => mockRepository.getBranches(familyId: tFamilyId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('nên trả về ServerFailure khi repository thất bại', () async {
    // Arrange
    const tFailure = ServerFailure(message: 'Lỗi tải danh sách chi');
    when(() => mockRepository.getBranches(familyId: tFamilyId))
        .thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, const Left(tFailure));
    verify(() => mockRepository.getBranches(familyId: tFamilyId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
