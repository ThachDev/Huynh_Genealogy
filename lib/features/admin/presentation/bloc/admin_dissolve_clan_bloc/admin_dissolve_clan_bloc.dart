import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecase/delete_family.dart';

part 'admin_dissolve_clan_event.dart';
part 'admin_dissolve_clan_state.dart';

class AdminDissolveClanBloc extends Bloc<AdminDissolveClanEvent, AdminDissolveClanState> {
  final DeleteFamily deleteFamily;

  AdminDissolveClanBloc({required this.deleteFamily}) : super(AdminDissolveClanInitial()) {
    on<DeleteFamilyRequested>(_onDeleteFamilyRequested);
  }

  Future<void> _onDeleteFamilyRequested(
    DeleteFamilyRequested event,
    Emitter<AdminDissolveClanState> emit,
  ) async {
    emit(AdminDissolveClanLoading());
    final failureOrSuccess = await deleteFamily(event.familyId);
    failureOrSuccess.fold(
      (failure) => emit(AdminDissolveClanFailure(message: failure.message)),
      (success) {
        if (success) {
          emit(AdminDissolveClanSuccess());
        } else {
          emit(const AdminDissolveClanFailure(message: 'Không thể giải tán dòng họ'));
        }
      },
    );
  }
}
