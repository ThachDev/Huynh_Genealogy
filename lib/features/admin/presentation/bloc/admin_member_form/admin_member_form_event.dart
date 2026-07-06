part of 'admin_member_form_bloc.dart';

abstract class AdminMemberFormEvent {}

class LoadAdminMemberFormEvent extends AdminMemberFormEvent {
  final int? memberId; // null = create new
  final int? familyId;
  LoadAdminMemberFormEvent({this.memberId, this.familyId});
}

class SubmitAdminMemberFormEvent extends AdminMemberFormEvent {
  final MemberEntity member;
  SubmitAdminMemberFormEvent(this.member);
}

class DeleteAdminMemberFormEvent extends AdminMemberFormEvent {
  final int memberId;
  DeleteAdminMemberFormEvent(this.memberId);
}

class ResetAdminMemberFormEvent extends AdminMemberFormEvent {}
