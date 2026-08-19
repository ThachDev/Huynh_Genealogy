import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/domain/entity/family_entity.dart';
import '../../../onboarding/domain/repository/onboarding_repository.dart';

class UpdateFamilyParams {

  UpdateFamilyParams({
    required this.id,
    this.name,
    this.description,
    this.origin,
    this.logoUrl,
  });
  final int id;
  final String? name;
  final String? description;
  final String? origin;
  final String? logoUrl;
}

class UpdateFamily implements UseCase<FamilyEntity, UpdateFamilyParams> {

  UpdateFamily(this.repository);
  final OnboardingRepository repository;

  @override
  Future<Either<Failure, FamilyEntity>> call(UpdateFamilyParams params) {
    return repository.updateFamily(
      id: params.id,
      name: params.name,
      description: params.description,
      origin: params.origin,
      logoUrl: params.logoUrl,
    );
  }
}
