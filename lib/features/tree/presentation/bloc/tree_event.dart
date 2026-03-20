part of 'tree_bloc.dart';

abstract class TreeEvent {}

class LoadTreeEvent extends TreeEvent {
  final int? branchId;
  final bool force;
  LoadTreeEvent({this.branchId, this.force = false});
}

class SelectMemberEvent extends TreeEvent {
  final int memberId;
  SelectMemberEvent(this.memberId);
}

class ExpandNodeEvent extends TreeEvent {
  final int memberId;
  ExpandNodeEvent(this.memberId);
}

class FilterByBranchEvent extends TreeEvent {
  final int? branchId;
  FilterByBranchEvent(this.branchId);
}
