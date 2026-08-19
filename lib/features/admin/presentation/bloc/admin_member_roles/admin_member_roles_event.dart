part of 'admin_member_roles_bloc.dart';

abstract class AdminMemberRolesEvent {}

class LoadAdminMemberRolesEvent extends AdminMemberRolesEvent {
  LoadAdminMemberRolesEvent({required this.familyId});
  final int familyId;
}

class UpdateAdminMemberRoleEvent extends AdminMemberRolesEvent {

  UpdateAdminMemberRoleEvent({
    required this.familyId,
    required this.userId,
    required this.role,
  });
  final int familyId;
  final int userId;
  final String role;
}
