import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import 'package:giatocviet/core/domain/entity/branch_entity.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecase/delete_member.dart';
import '../../../../user/domain/usecase/user_get_members.dart';
import '../../../../user/domain/usecase/user_get_branches.dart';
import '../../../domain/usecase/save_member.dart';

part 'admin_member_form_event.dart';
part 'admin_member_form_state.dart';

class AdminMemberFormBloc
    extends Bloc<AdminMemberFormEvent, AdminMemberFormState> {
  final UserGetMembers getMembers;
  final UserGetBranches getBranches;
  final SaveMember saveMember;
  final DeleteMember deleteMember;

  AdminMemberFormBloc({
    required this.getMembers,
    required this.getBranches,
    required this.saveMember,
    required this.deleteMember,
  }) : super(AdminMemberFormInitial()) {
    on<LoadAdminMemberFormEvent>(_onLoad);
    on<SubmitAdminMemberFormEvent>(_onSubmit, transformer: droppable());
    on<DeleteAdminMemberFormEvent>(_onDelete, transformer: droppable());
    on<ResetAdminMemberFormEvent>(_onReset);
  }

  Future<void> _onLoad(LoadAdminMemberFormEvent event,
      Emitter<AdminMemberFormState> emit) async {
    emit(AdminMemberFormLoading());
    // Fetch both members and branches
    final membersResult = await getMembers(const UserGetMembersParams());
    final branchesResult = await getBranches(NoParams());

    List<MemberEntity> allMembers = [];
    List<BranchEntity> allBranches = [];

    membersResult.fold(
      (failure) => null, // Ignore error for now, just show empty dropdowns
      (members) => allMembers = members.cast<MemberEntity>(),
    );

    branchesResult.fold(
      (failure) => null,
      (branches) => allBranches = branches,
    );

    if (event.memberId == null) {
      // Create mode
      emit(AdminMemberFormReady(
          member: null, members: allMembers, branches: allBranches));
      return;
    }

    // Edit mode
    final member = allMembers.where((m) => m.id == event.memberId).firstOrNull;
    emit(AdminMemberFormReady(
        member: member, members: allMembers, branches: allBranches));
  }

  Future<void> _onSubmit(SubmitAdminMemberFormEvent event,
      Emitter<AdminMemberFormState> emit) async {
    emit(AdminMemberFormSubmitting());
    final result = await saveMember(SaveMemberParams(member: event.member));
    result.fold(
      (failure) => emit(AdminMemberFormError(failure.message)),
      (saved) => emit(AdminMemberFormSuccess(member: saved)),
    );
  }

  Future<void> _onDelete(DeleteAdminMemberFormEvent event,
      Emitter<AdminMemberFormState> emit) async {
    emit(AdminMemberFormSubmitting());
    final result = await deleteMember(DeleteMemberParams(id: event.memberId));
    result.fold(
      (failure) => emit(AdminMemberFormError(failure.message)),
      (_) {
        // Tạo một entity dummy để trả về khi xoá
        const dummy = MemberEntity(
          id: 0,
          fullName: '',
          gender: Gender.unknown,
        );
        emit(AdminMemberFormSuccess(member: dummy, isDeleted: true));
      },
    );
  }

  void _onReset(
      ResetAdminMemberFormEvent event, Emitter<AdminMemberFormState> emit) {
    emit(AdminMemberFormInitial());
  }
}
