part of 'admin_member_form_bloc.dart';

abstract class AdminMemberFormState {}

class AdminMemberFormInitial extends AdminMemberFormState {}

class AdminMemberFormLoading extends AdminMemberFormState {}

class AdminMemberFormReady extends AdminMemberFormState {
  AdminMemberFormReady({this.member, this.members = const [], this.branches = const []});
  final MemberEntity? member; // null khi tạo mới
  final List<MemberEntity> members;
  final List<BranchEntity> branches;
}

class AdminMemberFormSubmitting extends AdminMemberFormState {}

class AdminMemberFormSuccess extends AdminMemberFormState {
  AdminMemberFormSuccess({required this.member, this.isDeleted = false});
  final MemberEntity member;
  final bool isDeleted;
}

class AdminMemberFormError extends AdminMemberFormState {
  AdminMemberFormError(this.message);
  final String message;
}
