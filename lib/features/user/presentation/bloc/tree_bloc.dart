import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giatocviet/core/domain/entity/branch_entity.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import '../../domain/usecase/get_branches.dart';
import '../../domain/usecase/get_members.dart';
import '../../../../core/usecases/usecase.dart';

part 'tree_event.dart';
part 'tree_state.dart';

class TreeBloc extends Bloc<TreeEvent, TreeState> {
  final GetMembers getMembers;
  final GetBranches getBranches;

  TreeBloc({
    required this.getMembers,
    required this.getBranches,
  }) : super(TreeInitial()) {
    on<LoadTreeEvent>(_onLoadTree);
    on<SelectMemberEvent>(_onSelectMember);
    on<FilterByBranchEvent>(_onFilterByBranch);
  }

  Future<void> _onLoadTree(
      LoadTreeEvent event, Emitter<TreeState> emit) async {
    emit(TreeLoading());

    final membersResult = await getMembers(
      GetMembersParams(branchId: event.branchId),
    );
    final branchesResult = await getBranches(NoParams());

    membersResult.fold(
      (failure) => emit(TreeError(failure.message)),
      (members) {
        branchesResult.fold(
          (failure) => emit(TreeError(failure.message)),
          (branches) => emit(TreeLoaded(
            members: members,
            branches: branches,
            filterBranchId: event.branchId,
          )),
        );
      },
    );
  }

  void _onSelectMember(SelectMemberEvent event, Emitter<TreeState> emit) {
    if (state is TreeLoaded) {
      emit((state as TreeLoaded).copyWith(selectedMemberId: event.memberId));
    }
  }

  Future<void> _onFilterByBranch(
      FilterByBranchEvent event, Emitter<TreeState> emit) async {
    add(LoadTreeEvent(branchId: event.branchId));
  }
}
