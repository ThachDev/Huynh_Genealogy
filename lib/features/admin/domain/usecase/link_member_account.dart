import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/member_account_link_repository.dart';

class LinkMemberAccount
    implements UseCase<LinkAccountResult, LinkMemberAccountParams> {

  LinkMemberAccount(this.repository);
  final MemberAccountLinkRepository repository;

  @override
  Future<Either<Failure, LinkAccountResult>> call(LinkMemberAccountParams params) {
    return repository.linkMemberAccount(
      familyId: params.familyId,
      memberId: params.memberId,
      email: params.email,
    );
  }
}

class LinkMemberAccountParams extends Equatable {

  const LinkMemberAccountParams({
    required this.familyId,
    required this.memberId,
    required this.email,
  });
  final int familyId;
  final int memberId;
  final String email;

  @override
  List<Object?> get props => [familyId, memberId, email];
}