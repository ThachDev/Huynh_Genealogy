part of 'branch_bloc.dart';

abstract class BranchState extends Equatable {
  const BranchState();

  @override
  List<Object?> get props => [];
}

class BranchInitial extends BranchState {}

class BranchSubmitting extends BranchState {}

class BranchSuccess extends BranchState {
  final BranchEntity branch;
  final bool isDeleted;

  const BranchSuccess({required this.branch, this.isDeleted = false});

  @override
  List<Object?> get props => [branch, isDeleted];
}

class BranchError extends BranchState {
  final String message;

  const BranchError(this.message);

  @override
  List<Object?> get props => [message];
}
