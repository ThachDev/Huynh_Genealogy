import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/member_account_link_entity.dart';
import '../repository/member_account_link_repository.dart';

class GetAccountLinks implements UseCase<List<MemberAccountLinkEntity>, int> {
  final MemberAccountLinkRepository repository;

  GetAccountLinks(this.repository);

  @override
  Future<Either<Failure, List<MemberAccountLinkEntity>>> call(int familyId) {
    return repository.getAccountLinks(familyId);
  }
}