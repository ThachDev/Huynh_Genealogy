import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/auth_repository.dart';

class GetCachedCredentials
    implements UseCase<Map<String, String>?, NoParams> {

  GetCachedCredentials(this.repository);
  final AuthRepository repository;

  @override
  Future<Either<Failure, Map<String, String>?>> call(NoParams params) {
    return repository.getCachedCredentials();
  }
}
