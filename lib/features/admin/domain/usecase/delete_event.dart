import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/domain/repository/events_repository.dart';

class DeleteEvent implements UseCase<bool, DeleteEventParams> {
  final EventsRepository repository;

  DeleteEvent(this.repository);

  @override
  Future<Either<Failure, bool>> call(DeleteEventParams params) {
    return repository.deleteEvent(params.id);
  }
}

class DeleteEventParams extends Equatable {
  final int id;

  const DeleteEventParams({required this.id});

  @override
  List<Object?> get props => [id];
}
