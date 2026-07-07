part of 'family_tree_bloc.dart';

abstract class FamilyTreeState {}

class FamilyTreeInitial extends FamilyTreeState {}

class FamilyTreeLoading extends FamilyTreeState {}

class FamilyTreeLoaded extends FamilyTreeState {
  final List<MemberEntity> members;
  final List<BranchEntity> branches;
  final int? selectedMemberId;
  final int? filterBranchId;
  final int? familyId;

  FamilyTreeLoaded({
    required this.members,
    required this.branches,
    this.selectedMemberId,
    this.filterBranchId,
    this.familyId,
  });

  FamilyTreeLoaded copyWith({
    List<MemberEntity>? members,
    List<BranchEntity>? branches,
    int? selectedMemberId,
    int? filterBranchId,
    int? familyId,
  }) {
    return FamilyTreeLoaded(
      members: members ?? this.members,
      branches: branches ?? this.branches,
      selectedMemberId: selectedMemberId ?? this.selectedMemberId,
      filterBranchId: filterBranchId ?? this.filterBranchId,
      familyId: familyId ?? this.familyId,
    );
  }
}

class FamilyTreeError extends FamilyTreeState {
  final String message;
  FamilyTreeError(this.message);
}
