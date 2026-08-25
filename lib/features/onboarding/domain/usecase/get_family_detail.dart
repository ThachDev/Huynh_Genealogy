import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../family_tree/domain/entities/family_entity.dart';
import '../repository/onboarding_repository.dart';

/// ============================================================================
/// USE CASE — GET FAMILY DETAIL (DOMAIN LAYER)
/// ============================================================================
/// Đảm nhận nghiệp vụ truy vấn chi tiết thông tin một dòng họ theo `familyId`.
/// Trả về `Either<Failure, FamilyEntity>`.
/// ============================================================================
class GetFamilyDetail implements UseCase<FamilyEntity, int> {

  GetFamilyDetail(this.repository);
  final OnboardingRepository repository;

  @override
  Future<Either<Failure, FamilyEntity>> call(int familyId) {
    return repository.getFamilyDetail(familyId: familyId);
  }
}
