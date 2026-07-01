import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecase/approve_request.dart';
import '../../../domain/usecase/reject_request.dart';
import '../../../domain/usecase/get_pending_requests.dart';
import '../../../domain/usecase/get_family_detail.dart';
import '../../../../../core/domain/entity/family_user_entity.dart';
import '../../../../../core/domain/entity/family_entity.dart';

part 'admin_pending_requests_event.dart';
part 'admin_pending_requests_state.dart';

class AdminPendingRequestsBloc extends Bloc<AdminPendingRequestsEvent, AdminPendingRequestsState> {
  final GetPendingRequests getPendingRequests;
  final ApproveRequest approveRequest;
  final RejectRequest rejectRequest;
  final GetFamilyDetail getFamilyDetail;

  AdminPendingRequestsBloc({
    required this.getPendingRequests,
    required this.approveRequest,
    required this.rejectRequest,
    required this.getFamilyDetail,
  }) : super(AdminPendingRequestsInitial()) {
    on<LoadAdminPendingRequestsEvent>(_onLoadPendingRequests);
    on<ApproveAdminRequestEvent>(_onApproveRequest);
    on<RejectAdminRequestEvent>(_onRejectRequest);
  }

  Future<void> _onLoadPendingRequests(
    LoadAdminPendingRequestsEvent event,
    Emitter<AdminPendingRequestsState> emit,
  ) async {
    emit(AdminPendingRequestsLoading());
    
    final failureOrRequests = await getPendingRequests(event.familyId);
    final failureOrFamily = await getFamilyDetail(event.familyId);

    failureOrRequests.fold(
      (failure) => emit(AdminPendingRequestsFailure(message: failure.message)),
      (requests) {
        failureOrFamily.fold(
          (failure) => emit(AdminPendingRequestsLoaded(requests: requests, family: null)),
          (family) => emit(AdminPendingRequestsLoaded(requests: requests, family: family)),
        );
      },
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

  Future<void> _onRejectRequest(
    RejectAdminRequestEvent event,
    Emitter<AdminPendingRequestsState> emit,
  ) async {
    emit(AdminPendingRequestsLoading());
    final failureOrSuccess = await rejectRequest(event.requestId);
    failureOrSuccess.fold(
      (failure) => emit(AdminPendingRequestsFailure(message: failure.message)),
      (success) {
        if (success) {
          emit(AdminRequestRejectedSuccess(requestId: event.requestId));
        } else {
          emit(const AdminPendingRequestsFailure(message: 'Từ chối thất bại'));
        }
      },
    );
  }
}
