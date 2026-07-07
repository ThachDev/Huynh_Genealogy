import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import '../../../family_tree/domain/repository/family_tree_repository.dart';

class GetMemberDetail implements UseCase<MemberEntity, int> {
  final FamilyTreeRepository repository;

  GetMemberDetail(this.repository);

  @override
  Future<Either<Failure, MemberEntity>> call(int id) {
    return repository.getMemberById(id);
  }
}
