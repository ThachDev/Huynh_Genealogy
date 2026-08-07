import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../family_tree/domain/repository/family_tree_repository.dart';

class PurgeTrash implements UseCase<int, PurgeTrashParams> {
  final FamilyTreeRepository repository;

  PurgeTrash(this.repository);

  @override
  Future<Either<Failure, int>> call(PurgeTrashParams params) {
    return repository.purgeTrash(days: params.days);
  }
}

class PurgeTrashParams extends Equatable {
  final int days;

  const PurgeTrashParams({this.days = 30});

  @override
  List<Object?> get props => [days];
}
