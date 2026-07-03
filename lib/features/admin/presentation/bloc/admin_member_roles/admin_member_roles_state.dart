part of 'admin_member_roles_bloc.dart';

abstract class AdminMemberRolesState {
  const AdminMemberRolesState();
}

class AdminMemberRolesInitial extends AdminMemberRolesState {}

class AdminMemberRolesLoading extends AdminMemberRolesState {}

class AdminMemberRolesLoaded extends AdminMemberRolesState {
  final List<FamilyUserEntity> members;
  const AdminMemberRolesLoaded({required this.members});
}

class AdminMemberRolesFailure extends AdminMemberRolesState {
  final String message;
  const AdminMemberRolesFailure({required this.message});
}

class AdminMemberRoleUpdatedSuccess extends AdminMemberRolesState {
  final int userId;
  final String role;
  const AdminMemberRoleUpdatedSuccess(
      {required this.userId, required this.role});
}
