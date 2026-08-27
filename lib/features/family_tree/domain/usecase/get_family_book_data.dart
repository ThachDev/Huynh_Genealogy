import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/family_book_data_entity.dart';
import '../repository/family_tree_repository.dart';

class GetFamilyBookDataParams extends Equatable {
  const GetFamilyBookDataParams({
    required this.familyId,
    this.startGeneration,
    this.endGeneration,
  });

  final int familyId;
  final int? startGeneration;
  final int? endGeneration;

  @override
  List<Object?> get props => [familyId, startGeneration, endGeneration];
}

class GetFamilyBookData
    implements UseCase<FamilyBookDataEntity, GetFamilyBookDataParams> {
  const GetFamilyBookData(this.repository);

  final FamilyTreeRepository repository;

  @override
  Future<Either<Failure, FamilyBookDataEntity>> call(
      GetFamilyBookDataParams params) {
    return repository.getFamilyBookData(
      familyId: params.familyId,
      startGeneration: params.startGeneration,
      endGeneration: params.endGeneration,
    );
  }
}
