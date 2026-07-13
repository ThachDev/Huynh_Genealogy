import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giatocviet/core/domain/entity/branch_entity.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import 'package:giatocviet/core/domain/entity/family_entity.dart';
import '../../domain/usecase/get_branches.dart';
import '../../domain/usecase/get_members.dart';
import '../../../admin/domain/usecase/get_family_detail.dart';

part 'family_tree_event.dart';
part 'family_tree_state.dart';

class FamilyTreeBloc extends Bloc<FamilyTreeEvent, FamilyTreeState> {
  final GetMembers getMembers;
  final GetBranches getBranches;
  final GetFamilyDetail getFamilyDetail;

  FamilyTreeBloc({
    required this.getMembers,
    required this.getBranches,
    required this.getFamilyDetail,
  }) : super(FamilyTreeInitial()) {
    on<FamilyTreeLoadEvent>(_onLoadTree);
    on<FamilyTreeSelectMemberEvent>(_onSelectMember);
    on<FamilyTreeFilterByBranchEvent>(_onFilterByBranch);
  }

  Future<void> _onLoadTree(
      FamilyTreeLoadEvent event, Emitter<FamilyTreeState> emit) async {
    emit(FamilyTreeLoading());

    try {
      FamilyEntity? family;
      if (event.familyId != null) {
        final familyResult = await getFamilyDetail(event.familyId!);
        familyResult.fold(
          (failure) => null,
          (fam) => family = fam,
        );
      }

      final membersResult = await getMembers(
        GetMembersParams(branchId: event.branchId, familyId: event.familyId),
      );
      final branchesResult = await getBranches(
        GetBranchesParams(familyId: event.familyId),
      );

      membersResult.fold(
        (failure) => emit(FamilyTreeError(failure.message)),
        (members) {
          branchesResult.fold(
            (failure) => emit(FamilyTreeError(failure.message)),
            (branches) => emit(FamilyTreeLoaded(
              members: members,
              branches: branches,
              filterBranchId: event.branchId,
              familyId: event.familyId,
              family: family,
            )),
          );
        },
      );
    } catch (e) {
      emit(FamilyTreeError('Có lỗi xảy ra khi tải dữ liệu: $e'));
    }
  }

  void _onSelectMember(FamilyTreeSelectMemberEvent event, Emitter<FamilyTreeState> emit) {
    if (state is FamilyTreeLoaded) {
      emit((state as FamilyTreeLoaded).copyWith(selectedMemberId: event.memberId));
    }
  }

  Future<void> _onFilterByBranch(
      FamilyTreeFilterByBranchEvent event, Emitter<FamilyTreeState> emit) async {
    final familyId = state is FamilyTreeLoaded ? (state as FamilyTreeLoaded).familyId : null;
    add(FamilyTreeLoadEvent(branchId: event.branchId, familyId: familyId));
  }
}
