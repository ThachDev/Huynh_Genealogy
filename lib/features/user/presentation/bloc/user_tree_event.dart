part of 'user_tree_bloc.dart';

abstract class UserTreeEvent {}

class UserTreeLoadEvent extends UserTreeEvent {
  final int? branchId;
  UserTreeLoadEvent({this.branchId});
}

class UserTreeSelectMemberEvent extends UserTreeEvent {
  final int memberId;
  UserTreeSelectMemberEvent(this.memberId);
}

class UserTreeExpandNodeEvent extends UserTreeEvent {
  final int memberId;
  UserTreeExpandNodeEvent(this.memberId);
}

class UserTreeFilterByBranchEvent extends UserTreeEvent {
  final int? branchId;
  UserTreeFilterByBranchEvent(this.branchId);
}
