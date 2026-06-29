import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/auth_repository.dart';

class ClearCredentials implements UseCase<void, NoParams> {
  final AuthRepository repository;

  ClearCredentials(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.clearCredentials();
  }
}
