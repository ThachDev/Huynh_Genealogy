part of 'member_form_bloc.dart';

abstract class MemberFormEvent {}

class LoadMemberFormEvent extends MemberFormEvent {
  final int? memberId; // null = create new
  LoadMemberFormEvent({this.memberId});
}

class SubmitMemberFormEvent extends MemberFormEvent {
  final MemberEntity member;
  final File? imageFile;
  SubmitMemberFormEvent(this.member, {this.imageFile});
}

class DeleteMemberFormEvent extends MemberFormEvent {
  final int memberId;
  DeleteMemberFormEvent(this.memberId);
}

class ResetMemberFormEvent extends MemberFormEvent {}
