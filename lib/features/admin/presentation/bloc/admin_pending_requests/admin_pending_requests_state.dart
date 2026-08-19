part of 'admin_pending_requests_bloc.dart';

abstract class AdminPendingRequestsState {
  const AdminPendingRequestsState();
}

class AdminPendingRequestsInitial extends AdminPendingRequestsState {}

class AdminPendingRequestsLoading extends AdminPendingRequestsState {}

class AdminPendingRequestsLoaded extends AdminPendingRequestsState {
  const AdminPendingRequestsLoaded({required this.requests, this.family});
  final List<FamilyUserEntity> requests;
  final FamilyEntity? family;
}

class AdminRequestApprovedSuccess extends AdminPendingRequestsState {
  const AdminRequestApprovedSuccess({required this.requestId});
  final int requestId;
}

class AdminRequestRejectedSuccess extends AdminPendingRequestsState {
  const AdminRequestRejectedSuccess({required this.requestId});
  final int requestId;
}

class AdminPendingRequestsFailure extends AdminPendingRequestsState {
  const AdminPendingRequestsFailure({required this.message});
  final String message;
}
