part of 'family_tree_bloc.dart';

abstract class FamilyTreeEvent {}

class FamilyTreeLoadEvent extends FamilyTreeEvent {
  FamilyTreeLoadEvent({this.branchId, this.familyId});
  final int? branchId;
  final int? familyId;
}

class FamilyTreeSelectMemberEvent extends FamilyTreeEvent {
  FamilyTreeSelectMemberEvent(this.memberId);
  final int memberId;
}

class FamilyTreeExpandNodeEvent extends FamilyTreeEvent {
  FamilyTreeExpandNodeEvent(this.memberId);
  final int memberId;
}

class FamilyTreeFilterByBranchEvent extends FamilyTreeEvent {
  FamilyTreeFilterByBranchEvent(this.branchId);
  final int? branchId;
}
