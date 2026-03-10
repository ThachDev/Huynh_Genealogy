part of 'tree_bloc.dart';

abstract class TreeState {}

class TreeInitial extends TreeState {}

class TreeLoading extends TreeState {}

class TreeLoaded extends TreeState {
  /// Danh sách thành viên đang hiển thị (đã qua filter)
  final List<MemberEntity> members;

  /// Toàn bộ thành viên gốc (chưa filter) — dùng để filter tức thì
  final List<MemberEntity> allMembers;
  final List<BranchEntity> branches;
  final int? selectedMemberId;
  final int? filterBranchId;

  TreeLoaded({
    required this.members,
    required this.allMembers,
    required this.branches,
    this.selectedMemberId,
    this.filterBranchId,
  });

  TreeLoaded copyWith({
    List<MemberEntity>? members,
    List<MemberEntity>? allMembers,
    List<BranchEntity>? branches,
    int? selectedMemberId,
    int? filterBranchId,
  }) {
    return TreeLoaded(
      members: members ?? this.members,
      allMembers: allMembers ?? this.allMembers,
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
