import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecase/save_branch.dart';
import '../../../domain/usecase/delete_branch.dart';
import '../../../../family_tree/domain/entities/branch_entity.dart';

part 'admin_branch_form_event.dart';
part 'admin_branch_form_state.dart';

class AdminBranchFormBloc extends Bloc<AdminBranchFormEvent, AdminBranchFormState> {

  AdminBranchFormBloc({
    required this.saveBranch,
    required this.deleteBranch,
  }) : super(AdminBranchFormInitial()) {
    on<SaveAdminBranchFormEvent>(_onSaveBranch);
    on<DeleteAdminBranchFormEvent>(_onDeleteBranch);
  }
  final SaveBranch saveBranch;
  final DeleteBranch deleteBranch;

  Future<void> _onSaveBranch(
    SaveAdminBranchFormEvent event,
    Emitter<AdminBranchFormState> emit,
  ) async {
    emit(AdminBranchFormLoading());
    final failureOrBranch = await saveBranch(event.branch);
    failureOrBranch.fold(
      (failure) => emit(AdminBranchFormError(failure.message)),
      (_) => emit(const AdminBranchFormSuccess()),
    );
  }

  Future<void> _onDeleteBranch(
    DeleteAdminBranchFormEvent event,
    Emitter<AdminBranchFormState> emit,
  ) async {
    emit(AdminBranchFormLoading());
    final failureOrSuccess = await deleteBranch(event.id);
    failureOrSuccess.fold(
      (failure) => emit(AdminBranchFormError(failure.message)),
      (_) => emit(const AdminBranchFormSuccess(isDeleted: true)),
    );
  }
}
