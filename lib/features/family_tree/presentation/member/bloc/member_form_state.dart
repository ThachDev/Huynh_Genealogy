part of 'member_form_bloc.dart';

abstract class MemberFormState {}

class MemberFormInitial extends MemberFormState {}

class MemberFormLoading extends MemberFormState {}

class MemberFormReady extends MemberFormState {
  final MemberEntity? member; // null khi tạo mới
  MemberFormReady({this.member});
}

class MemberFormSubmitting extends MemberFormState {}

class MemberFormSuccess extends MemberFormState {
  final MemberEntity member;
  final bool isDeleted;
  MemberFormSuccess({required this.member, this.isDeleted = false});
}

class MemberFormError extends MemberFormState {
  final String message;
  MemberFormError(this.message);
}
