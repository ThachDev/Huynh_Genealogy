import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/family_repository.dart';

class ApproveRequest implements UseCase<bool, int> {
  final FamilyRepository repository;

  ApproveRequest(this.repository);

  @override
  Future<Either<Failure, bool>> call(int requestId) {
    return repository.approveRequest(requestId: requestId);
  }
}
