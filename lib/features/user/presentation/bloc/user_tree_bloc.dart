import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giatocviet/core/domain/entity/branch_entity.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import '../../domain/usecase/user_get_branches.dart';
import '../../domain/usecase/user_get_members.dart';

part 'user_tree_event.dart';
part 'user_tree_state.dart';

class UserTreeBloc extends Bloc<UserTreeEvent, UserTreeState> {
  final UserGetMembers getMembers;
  final UserGetBranches getBranches;

  UserTreeBloc({
    required this.getMembers,
    required this.getBranches,
  }) : super(UserTreeInitial()) {
    on<UserTreeLoadEvent>(_onLoadTree);
    on<UserTreeSelectMemberEvent>(_onSelectMember);
    on<UserTreeFilterByBranchEvent>(_onFilterByBranch);
  }

  Future<void> _onLoadTree(
      UserTreeLoadEvent event, Emitter<UserTreeState> emit) async {
    emit(UserTreeLoading());

    final membersResult = await getMembers(
      UserGetMembersParams(branchId: event.branchId, familyId: event.familyId),
    );
    final branchesResult = await getBranches(
      UserGetBranchesParams(familyId: event.familyId),
    );

    membersResult.fold(
      (failure) => emit(UserTreeError(failure.message)),
      (members) {
        branchesResult.fold(
          (failure) => emit(UserTreeError(failure.message)),
          (branches) => emit(UserTreeLoaded(
            members: members,
            branches: branches,
            filterBranchId: event.branchId,
            familyId: event.familyId,
          )),
        );
      },
    );
  }

  void _onSelectMember(UserTreeSelectMemberEvent event, Emitter<UserTreeState> emit) {
    if (state is UserTreeLoaded) {
      emit((state as UserTreeLoaded).copyWith(selectedMemberId: event.memberId));
    }
  }

  Future<void> _onFilterByBranch(
      UserTreeFilterByBranchEvent event, Emitter<UserTreeState> emit) async {
    final familyId = state is UserTreeLoaded ? (state as UserTreeLoaded).familyId : null;
    add(UserTreeLoadEvent(branchId: event.branchId, familyId: familyId));
  }
}
