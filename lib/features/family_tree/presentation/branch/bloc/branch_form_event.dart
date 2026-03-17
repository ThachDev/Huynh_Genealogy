part of 'branch_form_bloc.dart';

abstract class BranchFormEvent extends Equatable {
  const BranchFormEvent();

  @override
  List<Object?> get props => [];
}

class SubmitBranchFormEvent extends BranchFormEvent {
  final BranchEntity branch;

  const SubmitBranchFormEvent(this.branch);

  @override
  List<Object?> get props => [branch];
}

class ResetBranchFormEvent extends BranchFormEvent {}
