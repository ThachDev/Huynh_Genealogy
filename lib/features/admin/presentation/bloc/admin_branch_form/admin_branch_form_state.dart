part of 'admin_branch_form_bloc.dart';

abstract class AdminBranchFormState {
  const AdminBranchFormState();
}

class AdminBranchFormInitial extends AdminBranchFormState {}

class AdminBranchFormLoading extends AdminBranchFormState {}

class AdminBranchFormSuccess extends AdminBranchFormState {
  final bool isDeleted;
  const AdminBranchFormSuccess({this.isDeleted = false});
}

class AdminBranchFormError extends AdminBranchFormState {
  final String message;
  const AdminBranchFormError(this.message);
}
