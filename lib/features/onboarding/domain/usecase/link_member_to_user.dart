import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/onboarding_repository.dart';

class LinkMemberToUser implements UseCase<bool, LinkMemberToUserParams> {

  LinkMemberToUser(this.repository);
  final OnboardingRepository repository;

  @override
  Future<Either<Failure, bool>> call(LinkMemberToUserParams params) {
    return repository.linkMemberToUser(
      userId: params.userId,
      memberId: params.memberId,
    );
  }
}

class LinkMemberToUserParams extends Equatable {

  const LinkMemberToUserParams({
    required this.userId,
    required this.memberId,
  });
  final int userId;
  final int memberId;

  @override
  List<Object?> get props => [userId, memberId];
}
