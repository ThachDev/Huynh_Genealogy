import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_family_tree/features/branch/domain/entities/branch.dart';
import 'package:app_family_tree/features/branch/domain/usecase/save_branch_usecase.dart';

part 'branch_event.dart';
part 'branch_state.dart';

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  final SaveBranchUseCase saveBranchUseCase;

  BranchBloc({
    required this.saveBranchUseCase,
  }) : super(BranchInitial()) {
    on<SubmitBranchEvent>(_onSubmit);
    on<ResetBranchEvent>(_onReset);
  }

  Future<void> _onSubmit(
    SubmitBranchEvent event,
    Emitter<BranchState> emit,
  ) async {
    emit(BranchSubmitting());
    final result = await saveBranchUseCase(event.branch);
    result.fold(
      (failure) => emit(BranchError(failure.message)),
      (saved) => emit(BranchSuccess(branch: saved)),
    );
  }

  void _onReset(ResetBranchEvent event, Emitter<BranchState> emit) {
    emit(BranchInitial());
  }
}
