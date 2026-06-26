import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giatocviet/core/domain/entity/branch_entity.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import '../../domain/usecase/user_get_branches.dart';
import '../../domain/usecase/user_get_members.dart';
import '../../../../core/usecases/usecase.dart';

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
      UserGetMembersParams(branchId: event.branchId),
    );
    final branchesResult = await getBranches(NoParams());

    membersResult.fold(
      (failure) => emit(UserTreeError(failure.message)),
      (members) {
        branchesResult.fold(
          (failure) => emit(UserTreeError(failure.message)),
          (branches) => emit(UserTreeLoaded(
            members: members,
            branches: branches,
            filterBranchId: event.branchId,
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
    add(UserTreeLoadEvent(branchId: event.branchId));
  }
}
