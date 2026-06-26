part of 'admin_member_form_bloc.dart';

abstract class AdminMemberFormState {}

class AdminMemberFormInitial extends AdminMemberFormState {}

class AdminMemberFormLoading extends AdminMemberFormState {}

class AdminMemberFormReady extends AdminMemberFormState {
  final MemberEntity? member; // null khi tạo mới
  AdminMemberFormReady({this.member});
}

class AdminMemberFormSubmitting extends AdminMemberFormState {}

class AdminMemberFormSuccess extends AdminMemberFormState {
  final MemberEntity member;
  final bool isDeleted;
  AdminMemberFormSuccess({required this.member, this.isDeleted = false});
}

class AdminMemberFormError extends AdminMemberFormState {
  final String message;
  AdminMemberFormError(this.message);
}
