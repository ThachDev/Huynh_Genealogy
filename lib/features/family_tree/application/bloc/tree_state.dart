part of 'tree_bloc.dart';

abstract class TreeState {}

class TreeInitial extends TreeState {}

class TreeLoading extends TreeState {}

class TreeLoaded extends TreeState {
  final List<MemberEntity> members;
  final List<BranchEntity> branches;
  final int? selectedMemberId;
  final int? filterBranchId;

  TreeLoaded({
    required this.members,
    required this.branches,
    this.selectedMemberId,
    this.filterBranchId,
  });

  TreeLoaded copyWith({
    List<MemberEntity>? members,
    List<BranchEntity>? branches,
    int? selectedMemberId,
    int? filterBranchId,
  }) {
    return TreeLoaded(
      members: members ?? this.members,
      branches: branches ?? this.branches,
      selectedMemberId: selectedMemberId ?? this.selectedMemberId,
      filterBranchId: filterBranchId ?? this.filterBranchId,
    );
  }
}

class TreeError extends TreeState {
  final String message;
  TreeError(this.message);
}






