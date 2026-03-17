part of 'branch_form_bloc.dart';

abstract class BranchFormState extends Equatable {
  const BranchFormState();

  @override
  List<Object?> get props => [];
}

class BranchFormInitial extends BranchFormState {}

class BranchFormSubmitting extends BranchFormState {}

class BranchFormSuccess extends BranchFormState {
  final BranchEntity branch;
  final bool isDeleted;

  const BranchFormSuccess({required this.branch, this.isDeleted = false});

  @override
  List<Object?> get props => [branch, isDeleted];
}

class BranchFormError extends BranchFormState {
  final String message;

  const BranchFormError(this.message);

  @override
  List<Object?> get props => [message];
}
