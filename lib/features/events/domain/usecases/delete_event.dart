import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/events_repository.dart';

class DeleteEvent implements UseCase<bool, DeleteEventParams> {

  DeleteEvent(this.repository);
  final EventsRepository repository;

  @override
  Future<Either<Failure, bool>> call(DeleteEventParams params) {
    return repository.deleteEvent(params.id);
  }
}

class DeleteEventParams extends Equatable {

  const DeleteEventParams({required this.id});
  final int id;

  @override
  List<Object?> get props => [id];
}
