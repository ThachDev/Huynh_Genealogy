import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giatocviet/core/domain/entity/family_user_entity.dart';
import 'package:giatocviet/features/admin/domain/usecase/get_approved_members.dart';
import 'package:giatocviet/features/admin/domain/usecase/update_member_role.dart';

part 'admin_member_roles_event.dart';
part 'admin_member_roles_state.dart';

class AdminMemberRolesBloc
    extends Bloc<AdminMemberRolesEvent, AdminMemberRolesState> {
  final GetApprovedMembers getApprovedMembers;
  final UpdateMemberRole updateMemberRole;

  AdminMemberRolesBloc({
    required this.getApprovedMembers,
    required this.updateMemberRole,
  }) : super(AdminMemberRolesInitial()) {
    on<LoadAdminMemberRolesEvent>(_onLoadAdminMemberRoles);
    on<UpdateAdminMemberRoleEvent>(_onUpdateAdminMemberRole);
  }

  Future<void> _onLoadAdminMemberRoles(
    LoadAdminMemberRolesEvent event,
    Emitter<AdminMemberRolesState> emit,
  ) async {
    emit(AdminMemberRolesLoading());
    final failureOrMembers = await getApprovedMembers(event.familyId);
    failureOrMembers.fold(
      (failure) => emit(AdminMemberRolesFailure(message: failure.message)),
      (members) => emit(AdminMemberRolesLoaded(members: members)),
    );
  }

  Future<void> _onUpdateAdminMemberRole(
    UpdateAdminMemberRoleEvent event,
    Emitter<AdminMemberRolesState> emit,
  ) async {
    emit(AdminMemberRolesLoading());
    final failureOrSuccess = await updateMemberRole(
      UpdateMemberRoleParams(
        familyId: event.familyId,
        userId: event.userId,
        role: event.role,
      ),
    );
    failureOrSuccess.fold(
      (failure) => emit(AdminMemberRolesFailure(message: failure.message)),
      (success) {
        if (success) {
          emit(AdminMemberRoleUpdatedSuccess(
              userId: event.userId, role: event.role));
        } else {
          emit(const AdminMemberRolesFailure(message: 'Phân quyền thất bại'));
        }
      },
    );
  }
}
