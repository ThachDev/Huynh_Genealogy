import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giatocviet/core/domain/entity/family_user_entity.dart';
import '../../../domain/usecase/get_approved_members.dart';
import '../../../domain/usecase/transfer_ownership.dart';

part 'admin_transfer_ownership_event.dart';
part 'admin_transfer_ownership_state.dart';

class AdminTransferOwnershipBloc
    extends Bloc<AdminTransferOwnershipEvent, AdminTransferOwnershipState> {
  final GetApprovedMembers getApprovedMembers;
  final TransferOwnership transferOwnership;

  AdminTransferOwnershipBloc({
    required this.getApprovedMembers,
    required this.transferOwnership,
  }) : super(AdminTransferOwnershipInitial()) {
    on<LoadCandidatesEvent>(_onLoadCandidates);
    on<TransferOwnershipEvent>(_onTransferOwnership);
  }

  Future<void> _onLoadCandidates(
    LoadCandidatesEvent event,
    Emitter<AdminTransferOwnershipState> emit,
  ) async {
    emit(AdminTransferOwnershipLoading());
    final failureOrMembers = await getApprovedMembers(event.familyId);
    failureOrMembers.fold(
      (failure) => emit(AdminTransferOwnershipFailure(message: failure.message)),
      (members) {
        final candidates = members
            .where((m) =>
                m.role.toUpperCase() != 'OWNER' &&
                m.status.toUpperCase() == 'APPROVED')
            .toList();
        emit(AdminTransferOwnershipLoaded(candidates: candidates));
      },
    );
  }

  Future<void> _onTransferOwnership(
    TransferOwnershipEvent event,
    Emitter<AdminTransferOwnershipState> emit,
  ) async {
    emit(AdminTransferOwnershipSubmitting());
    final failureOrSuccess = await transferOwnership(
      TransferOwnershipParams(
        familyId: event.familyId,
        newOwnerUserId: event.newOwnerUserId,
      ),
    );
    failureOrSuccess.fold(
      (failure) =>
          emit(AdminTransferOwnershipFailure(message: failure.message)),
      (success) {
        if (success) {
          emit(AdminTransferOwnershipSuccess());
        } else {
          emit(const AdminTransferOwnershipFailure(
              message: 'Không thể chuyển nhượng quyền Trưởng tộc'));
        }
      },
    );
  }
}
