import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_family_tree/features/family_tree/domain/entity/branch_entity.dart';
import 'package:app_family_tree/features/family_tree/domain/entity/member_entity.dart';
import 'package:app_family_tree/features/family_tree/domain/usecase/get_branches.dart';
import 'package:app_family_tree/features/family_tree/domain/usecase/get_members.dart';
import 'package:app_family_tree/base/usecase.dart';

part 'tree_event.dart';
part 'tree_state.dart';

class TreeBloc extends Bloc<TreeEvent, TreeState> {
  final GetMembers getMembers;
  final GetBranches getBranches;

  TreeBloc({required this.getMembers, required this.getBranches})
    : super(TreeInitial()) {
    on<LoadTreeEvent>(_onLoadTree);
    on<SelectMemberEvent>(_onSelectMember);
    on<FilterByBranchEvent>(_onFilterByBranch);
  }

  Future<void> _onLoadTree(LoadTreeEvent event, Emitter<TreeState> emit) async {
    emit(TreeLoading());

    final membersResult = await getMembers(
      GetMembersParams(branchId: null), // Load tất cả thành viên
    );
    final branchesResult = await getBranches(NoParams());

    membersResult.fold((failure) => emit(TreeError(failure.message)), (
      allMembers,
    ) {
      branchesResult.fold(
        (failure) => emit(TreeError(failure.message)),
        (branches) => emit(
          TreeLoaded(
            allMembers: allMembers.cast<MemberEntity>(),
            members: allMembers.cast<MemberEntity>(),
            branches: branches.cast<BranchEntity>(),
            filterBranchId: null,
          ),
        ),
      );
    });
  }

  void _onSelectMember(SelectMemberEvent event, Emitter<TreeState> emit) {
    if (state is TreeLoaded) {
      emit((state as TreeLoaded).copyWith(selectedMemberId: event.memberId));
    }
  }

  /// Filter tức thì từ allMembers đã cache — không cần async, không emit TreeLoading
  void _onFilterByBranch(FilterByBranchEvent event, Emitter<TreeState> emit) {
    if (state is! TreeLoaded) return;
    final current = state as TreeLoaded;

    final filtered = event.branchId == null
        ? current.allMembers
        : current.allMembers
              .where((m) => m.branchId == event.branchId)
              .toList();

    emit(current.copyWith(members: filtered, filterBranchId: event.branchId));
  }
}
