import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giatocviet/features/admin/domain/usecase/delete_member.dart';
import 'package:giatocviet/features/family_tree/domain/repository/family_tree_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockFamilyTreeRepository extends Mock implements FamilyTreeRepository {}

void main() {
  late DeleteMember usecase;
  late MockFamilyTreeRepository mockRepository;

  setUp(() {
    mockRepository = MockFamilyTreeRepository();
    usecase = DeleteMember(mockRepository);
  });

  const tMemberId = 42;
  const tParams = DeleteMemberParams(id: tMemberId);

  test('nếu xóa thành viên thành công thì trả về Right(true)', () async {
    // Arrange
    when(() => mockRepository.deleteMember(tMemberId))
        .thenAnswer((_) async => const Right(true));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, const Right(true));
    verify(() => mockRepository.deleteMember(tMemberId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
