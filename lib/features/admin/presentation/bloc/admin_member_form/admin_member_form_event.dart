part of 'admin_member_form_bloc.dart';

abstract class AdminMemberFormEvent {}

class LoadAdminMemberFormEvent extends AdminMemberFormEvent {
  LoadAdminMemberFormEvent({this.memberId, this.familyId});
  final int? memberId; // null = create new
  final int? familyId;
}

class SubmitAdminMemberFormEvent extends AdminMemberFormEvent {
  SubmitAdminMemberFormEvent(this.member);
  final MemberEntity member;
}

class DeleteAdminMemberFormEvent extends AdminMemberFormEvent {
  DeleteAdminMemberFormEvent(this.memberId, {this.reassignChildrenToParent = false});
  final int memberId;
  final bool reassignChildrenToParent;
}

class ResetAdminMemberFormEvent extends AdminMemberFormEvent {}
