import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_family_tree/features/branch/domain/entities/branch.dart';
import 'package:app_family_tree/features/member/domain/entities/member.dart';
import 'package:app_family_tree/core/usecase/usecase.dart';
import 'package:app_family_tree/features/branch/domain/usecase/get_branches_usecase.dart';
import 'package:app_family_tree/features/member/domain/usecase/get_members_usecase.dart';

part 'tree_event.dart';
part 'tree_state.dart';

class TreeBloc extends Bloc<TreeEvent, TreeState> {
  final GetMembersUseCase getMembersUseCase;
  final GetBranchesUseCase getBranchesUseCase;

  TreeBloc({required this.getMembersUseCase, required this.getBranchesUseCase})
    : super(TreeInitial()) {
    on<LoadTreeEvent>(_onLoadTree);
    on<SelectMemberEvent>(_onSelectMember);
    on<FilterByBranchEvent>(_onFilterByBranch);
  }

  Future<void> _onLoadTree(LoadTreeEvent event, Emitter<TreeState> emit) async {
    if (state is TreeLoading) return;
    if (state is TreeLoaded && event.branchId == null && !event.force) return;

    emit(TreeLoading());

    final membersResult = await getMembersUseCase(
      GetMembersParams(branchId: event.branchId),
    );
    final branchesResult = await getBranchesUseCase(NoParams());

    membersResult.fold((failure) => emit(TreeError(failure.message)), (
      allMembers,
    ) {
      branchesResult.fold(
        (failure) => emit(TreeError(failure.message)),
        (branches) => emit(
          TreeLoaded(
            allMembers: List<MemberEntity>.from(allMembers),
            members: List<MemberEntity>.from(allMembers),
            branches: List<BranchEntity>.from(branches),
            filterBranchId: event.branchId,
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

  void _onFilterByBranch(FilterByBranchEvent event, Emitter<TreeState> emit) {
    if (state is! TreeLoaded) return;
    final current = state as TreeLoaded;

    final filtered = event.branchId == null
        ? current.allMembers
        : current.allMembers
              .where((m) => m.branchId == event.branchId)
              .toList();

    emit(
      current.copyWith(
        members: filtered,
        filterBranchId: event.branchId,
        resetFilter: event.branchId == null,
      ),
    );
  }
}
