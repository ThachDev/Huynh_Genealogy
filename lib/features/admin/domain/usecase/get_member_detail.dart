import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import '../../../user/domain/repository/user_tree_repository.dart';

class GetMemberDetail implements UseCase<MemberEntity, int> {
  final UserTreeRepository repository;

  GetMemberDetail(this.repository);

  @override
  Future<Either<Failure, MemberEntity>> call(int id) {
    return repository.getMemberById(id);
  }
}
