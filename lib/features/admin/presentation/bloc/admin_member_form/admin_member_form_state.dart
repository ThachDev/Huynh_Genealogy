part of 'admin_member_form_bloc.dart';

abstract class AdminMemberFormState {}

class AdminMemberFormInitial extends AdminMemberFormState {}

class AdminMemberFormLoading extends AdminMemberFormState {}

class AdminMemberFormReady extends AdminMemberFormState {
  final MemberEntity? member; // null khi tạo mới
  final List<MemberEntity> members;
  final List<BranchEntity> branches;
  AdminMemberFormReady({this.member, this.members = const [], this.branches = const []});
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
