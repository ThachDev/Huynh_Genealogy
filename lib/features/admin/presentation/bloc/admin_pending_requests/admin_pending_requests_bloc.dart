import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecase/approve_request.dart';
import '../../../domain/usecase/get_pending_requests.dart';
import '../../../../../core/domain/entity/family_user_entity.dart';

part 'admin_pending_requests_event.dart';
part 'admin_pending_requests_state.dart';

class AdminPendingRequestsBloc extends Bloc<AdminPendingRequestsEvent, AdminPendingRequestsState> {
  final GetPendingRequests getPendingRequests;
  final ApproveRequest approveRequest;

  AdminPendingRequestsBloc({
    required this.getPendingRequests,
    required this.approveRequest,
  }) : super(AdminPendingRequestsInitial()) {
    on<LoadAdminPendingRequestsEvent>(_onLoadPendingRequests);
    on<ApproveAdminRequestEvent>(_onApproveRequest);
  }

  Future<void> _onLoadPendingRequests(
    LoadAdminPendingRequestsEvent event,
    Emitter<AdminPendingRequestsState> emit,
  ) async {
    emit(AdminPendingRequestsLoading());
    final failureOrRequests = await getPendingRequests(event.familyId);
    failureOrRequests.fold(
      (failure) => emit(AdminPendingRequestsFailure(message: failure.message)),
      (requests) => emit(AdminPendingRequestsLoaded(requests: requests)),
    );
  }

  Future<void> _onApproveRequest(
    ApproveAdminRequestEvent event,
    Emitter<AdminPendingRequestsState> emit,
  ) async {
    emit(AdminPendingRequestsLoading());
    final failureOrSuccess = await approveRequest(event.requestId);
    failureOrSuccess.fold(
      (failure) => emit(AdminPendingRequestsFailure(message: failure.message)),
      (success) {
        if (success) {
          emit(AdminRequestApprovedSuccess(requestId: event.requestId));
        } else {
          emit(const AdminPendingRequestsFailure(message: 'Phê duyệt thất bại'));
        }
      },
    );
  }
}
