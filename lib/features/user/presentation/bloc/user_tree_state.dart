part of 'user_tree_bloc.dart';

abstract class UserTreeState {}

class UserTreeInitial extends UserTreeState {}

class UserTreeLoading extends UserTreeState {}

class UserTreeLoaded extends UserTreeState {
  final List<MemberEntity> members;
  final List<BranchEntity> branches;
  final int? selectedMemberId;
  final int? filterBranchId;

  UserTreeLoaded({
    required this.members,
    required this.branches,
    this.selectedMemberId,
    this.filterBranchId,
  });

  UserTreeLoaded copyWith({
    List<MemberEntity>? members,
    List<BranchEntity>? branches,
    int? selectedMemberId,
    int? filterBranchId,
  }) {
    return UserTreeLoaded(
      members: members ?? this.members,
      branches: branches ?? this.branches,
      selectedMemberId: selectedMemberId ?? this.selectedMemberId,
      filterBranchId: filterBranchId ?? this.filterBranchId,
    );
  }
}

class UserTreeError extends UserTreeState {
  final String message;
  UserTreeError(this.message);
}
