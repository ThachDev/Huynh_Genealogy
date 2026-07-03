part of 'admin_member_roles_bloc.dart';

abstract class AdminMemberRolesEvent {}

class LoadAdminMemberRolesEvent extends AdminMemberRolesEvent {
  final int familyId;
  LoadAdminMemberRolesEvent({required this.familyId});
}

class UpdateAdminMemberRoleEvent extends AdminMemberRolesEvent {
  final int familyId;
  final int userId;
  final String role;

  UpdateAdminMemberRoleEvent({
    required this.familyId,
    required this.userId,
    required this.role,
  });
}
