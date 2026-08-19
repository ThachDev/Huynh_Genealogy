import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/domain/entity/family_entity.dart';
import '../repository/onboarding_repository.dart';

/// ============================================================================
/// USE CASE — CREATE FAMILY (DOMAIN LAYER)
/// ============================================================================
/// Mỗi UseCase đảm nhận duy nhất một chức năng nghiệp vụ (Single Responsibility Principle).
/// `CreateFamily` thực hiện nghiệp vụ tạo dòng họ mới trong hệ thống.
///
/// Implements `UseCase<Type, Params>`:
///   - `Type`: Kết quả thành công mong muốn (`FamilyEntity`).
///   - `Params`: Tham số đầu vào truyền vào phương thức `call()` (`CreateFamilyParams`).
/// ============================================================================
class CreateFamily implements UseCase<FamilyEntity, CreateFamilyParams> {

  CreateFamily(this.repository);
  final OnboardingRepository repository;

  @override
  Future<Either<Failure, FamilyEntity>> call(CreateFamilyParams params) {
    return repository.createFamily(
      name: params.name,
      description: params.description,
      logoUrl: params.logoUrl,
      userId: params.userId,
    );
  }
}

class CreateFamilyParams extends Equatable {

  const CreateFamilyParams({
    required this.name,
    this.description,
    this.logoUrl,
    required this.userId,
  });
  final String name;
  final String? description;
  final String? logoUrl;
  final int userId;

  @override
  List<Object?> get props => [name, description, logoUrl, userId];
}
