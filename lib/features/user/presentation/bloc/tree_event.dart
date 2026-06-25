part of 'tree_bloc.dart';

abstract class TreeEvent {}

class LoadTreeEvent extends TreeEvent {
  final int? branchId;
  LoadTreeEvent({this.branchId});
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
