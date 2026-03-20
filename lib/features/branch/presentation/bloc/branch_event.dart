part of 'branch_bloc.dart';

abstract class BranchEvent extends Equatable {
  const BranchEvent();

  @override
  List<Object?> get props => [];
}

class SubmitBranchEvent extends BranchEvent {
  final BranchEntity branch;

  const SubmitBranchEvent(this.branch);

  @override
  List<Object?> get props => [branch];
}

class ResetBranchEvent extends BranchEvent {}
