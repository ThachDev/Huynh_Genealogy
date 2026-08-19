part of 'admin_branch_form_bloc.dart';

abstract class AdminBranchFormState {
  const AdminBranchFormState();
}

class AdminBranchFormInitial extends AdminBranchFormState {}

class AdminBranchFormLoading extends AdminBranchFormState {}

class AdminBranchFormSuccess extends AdminBranchFormState {
  const AdminBranchFormSuccess({this.isDeleted = false});
  final bool isDeleted;
}

class AdminBranchFormError extends AdminBranchFormState {
  const AdminBranchFormError(this.message);
  final String message;
}
