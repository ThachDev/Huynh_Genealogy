part of 'admin_branch_form_bloc.dart';

abstract class AdminBranchFormEvent {}

class SaveAdminBranchFormEvent extends AdminBranchFormEvent {
  final BranchEntity branch;
  SaveAdminBranchFormEvent(this.branch);
}

class DeleteAdminBranchFormEvent extends AdminBranchFormEvent {
  final int id;
  DeleteAdminBranchFormEvent(this.id);
}
