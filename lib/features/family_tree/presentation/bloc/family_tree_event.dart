part of 'family_tree_bloc.dart';

abstract class FamilyTreeEvent {}

class FamilyTreeLoadEvent extends FamilyTreeEvent {
  final int? branchId;
  final int? familyId;
  FamilyTreeLoadEvent({this.branchId, this.familyId});
}

class FamilyTreeSelectMemberEvent extends FamilyTreeEvent {
  final int memberId;
  FamilyTreeSelectMemberEvent(this.memberId);
}

class FamilyTreeExpandNodeEvent extends FamilyTreeEvent {
  final int memberId;
  FamilyTreeExpandNodeEvent(this.memberId);
}

class FamilyTreeFilterByBranchEvent extends FamilyTreeEvent {
  final int? branchId;
  FamilyTreeFilterByBranchEvent(this.branchId);
}
