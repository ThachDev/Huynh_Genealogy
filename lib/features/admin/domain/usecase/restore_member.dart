import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import '../../../family_tree/domain/repository/family_tree_repository.dart';

class RestoreMember implements UseCase<MemberEntity, int> {

  RestoreMember(this.repository);
  final FamilyTreeRepository repository;

  @override
  Future<Either<Failure, MemberEntity>> call(int id) {
    return repository.restoreMember(id);
  }
}
