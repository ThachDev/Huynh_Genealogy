part of 'admin_member_roles_bloc.dart';

abstract class AdminMemberRolesState {
  const AdminMemberRolesState();
}

class AdminMemberRolesInitial extends AdminMemberRolesState {}

class AdminMemberRolesLoading extends AdminMemberRolesState {}

class AdminMemberRolesLoaded extends AdminMemberRolesState {
  const AdminMemberRolesLoaded({required this.members});
  final List<FamilyUserEntity> members;
}

class AdminMemberRolesFailure extends AdminMemberRolesState {
  const AdminMemberRolesFailure({required this.message});
  final String message;
}

class AdminMemberRoleUpdatedSuccess extends AdminMemberRolesState {
  const AdminMemberRoleUpdatedSuccess(
      {required this.userId, required this.role});
  final int userId;
  final String role;
}
