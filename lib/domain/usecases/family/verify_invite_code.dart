import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/family_repository.dart';

class VerifyInviteCode implements UseCase<Map<String, dynamic>, String> {
  final FamilyRepository repository;

  VerifyInviteCode(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(String code) {
    return repository.verifyInviteCode(code: code);
  }
}
