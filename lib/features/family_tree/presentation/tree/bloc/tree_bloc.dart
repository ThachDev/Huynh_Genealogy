import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/branch.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/member.dart';
import 'package:app_family_tree/base/usecase.dart';
import 'package:app_family_tree/features/family_tree/domain/usecase/get_branches_usecase.dart';
import 'package:app_family_tree/features/family_tree/domain/usecase/get_members_usecase.dart';

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
    // Nếu đang load thì bỏ qua để tránh conflict
    if (state is TreeLoading) return;

    // Nếu đã load rồi và không yêu cầu branch cụ thể (trường hợp load all mặc định)
    // thì không cần load lại để tránh UI giật lag khi chuyển tab
    // TRỪ KHI: yêu cầu force reload (sau khi thêm/sửa thành viên)
    if (state is TreeLoaded && event.branchId == null && !event.force) return;

    // Chỉ emit loading nếu thực sự cần load mới hoặc reload
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

  /// Filter tức thì từ allMembers đã cache — không cần async, không emit TreeLoading
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
