import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/domain/entity/family_entity.dart';
import '../repository/onboarding_repository.dart';

class CreateFamily implements UseCase<FamilyEntity, CreateFamilyParams> {
  final OnboardingRepository repository;

  CreateFamily(this.repository);

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
  final String name;
  final String? description;
  final String? logoUrl;
  final int userId;

  const CreateFamilyParams({
    required this.name,
    this.description,
    this.logoUrl,
    required this.userId,
  });

  @override
  List<Object?> get props => [name, description, logoUrl, userId];
}
