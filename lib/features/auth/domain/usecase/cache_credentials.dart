import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/auth_repository.dart';

class CacheCredentials implements UseCase<void, CacheCredentialsParams> {

  CacheCredentials(this.repository);
  final AuthRepository repository;

  @override
  Future<Either<Failure, void>> call(CacheCredentialsParams params) {
    return repository.cacheCredentials(
      email: params.email,
      password: params.password,
    );
  }
}

class CacheCredentialsParams extends Equatable {

  const CacheCredentialsParams({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
