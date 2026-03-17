import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/branch.dart';
import 'package:app_family_tree/features/family_tree/domain/usecase/save_branch_usecase.dart';

part 'branch_form_event.dart';
part 'branch_form_state.dart';

class BranchFormBloc extends Bloc<BranchFormEvent, BranchFormState> {
  final SaveBranchUseCase saveBranchUseCase;

  BranchFormBloc({
    required this.saveBranchUseCase,
  }) : super(BranchFormInitial()) {
    on<SubmitBranchFormEvent>(_onSubmit);
    on<ResetBranchFormEvent>(_onReset);
  }

  Future<void> _onSubmit(
    SubmitBranchFormEvent event,
    Emitter<BranchFormState> emit,
  ) async {
    emit(BranchFormSubmitting());
    final result = await saveBranchUseCase(event.branch);
    result.fold(
      (failure) => emit(BranchFormError(failure.message)),
      (saved) => emit(BranchFormSuccess(branch: saved)),
    );
  }

  void _onReset(ResetBranchFormEvent event, Emitter<BranchFormState> emit) {
    emit(BranchFormInitial());
  }
}
