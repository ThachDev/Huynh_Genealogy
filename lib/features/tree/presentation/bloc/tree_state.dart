part of 'tree_bloc.dart';

abstract class TreeState extends Equatable {
  const TreeState();

  @override
  List<Object?> get props => [];
}

class TreeInitial extends TreeState {}

class TreeLoading extends TreeState {}

class TreeLoaded extends TreeState {
  final List<MemberEntity> allMembers;
  final List<MemberEntity> members;
  final List<BranchEntity> branches;
  final int? selectedMemberId;
  final int? filterBranchId;

  const TreeLoaded({
    required this.allMembers,
    required this.members,
    required this.branches,
    this.selectedMemberId,
    this.filterBranchId,
  });

  TreeLoaded copyWith({
    List<MemberEntity>? allMembers,
    List<MemberEntity>? members,
    List<BranchEntity>? branches,
    int? selectedMemberId,
    int? filterBranchId,
    bool resetFilter = false,
  }) {
    return TreeLoaded(
      allMembers: allMembers ?? this.allMembers,
      members: members ?? this.members,
      branches: branches ?? this.branches,
      selectedMemberId: selectedMemberId ?? this.selectedMemberId,
      filterBranchId: resetFilter ? null : (filterBranchId ?? this.filterBranchId),
    );
  }

  @override
  List<Object?> get props => [
    allMembers,
    members,
    branches,
    selectedMemberId,
    filterBranchId,
  ];
}

class TreeError extends TreeState {
  final String message;
  const TreeError(this.message);

  @override
  List<Object?> get props => [message];
}
