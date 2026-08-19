part of 'admin_branch_form_bloc.dart';

abstract class AdminBranchFormEvent {}

class SaveAdminBranchFormEvent extends AdminBranchFormEvent {
  SaveAdminBranchFormEvent(this.branch);
  final BranchEntity branch;
}

class DeleteAdminBranchFormEvent extends AdminBranchFormEvent {
  DeleteAdminBranchFormEvent(this.id);
  final int id;
}
