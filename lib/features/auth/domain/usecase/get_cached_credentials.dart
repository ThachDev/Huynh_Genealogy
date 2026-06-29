import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/auth_repository.dart';

class GetCachedCredentials
    implements UseCase<Map<String, String>?, NoParams> {
  final AuthRepository repository;

  GetCachedCredentials(this.repository);

  @override
  Future<Either<Failure, Map<String, String>?>> call(NoParams params) {
    return repository.getCachedCredentials();
  }
}
