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
  final FamilyEntity? family;

  FamilyTreeLoaded({
    required this.members,
    required this.branches,
    this.selectedMemberId,
    this.filterBranchId,
    this.familyId,
    this.family,
  });

  FamilyTreeLoaded copyWith({
    List<MemberEntity>? members,
    List<BranchEntity>? branches,
    int? selectedMemberId,
    int? filterBranchId,
    int? familyId,
    FamilyEntity? family,
  }) {
    return FamilyTreeLoaded(
      members: members ?? this.members,
      branches: branches ?? this.branches,
      selectedMemberId: selectedMemberId ?? this.selectedMemberId,
      filterBranchId: filterBranchId ?? this.filterBranchId,
      familyId: familyId ?? this.familyId,
      family: family ?? this.family,
    );
  }
}

class FamilyTreeError extends FamilyTreeState {
  final String message;
  FamilyTreeError(this.message);
}
