import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/onboarding_repository.dart';

class VerifyInviteCode implements UseCase<Map<String, dynamic>, String> {
  final OnboardingRepository repository;

  VerifyInviteCode(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(String code) {
    return repository.verifyInviteCode(code: code);
  }
}
