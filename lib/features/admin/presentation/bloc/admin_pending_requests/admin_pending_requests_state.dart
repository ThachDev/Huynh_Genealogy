part of 'admin_pending_requests_bloc.dart';

abstract class AdminPendingRequestsState {
  const AdminPendingRequestsState();
}

class AdminPendingRequestsInitial extends AdminPendingRequestsState {}

class AdminPendingRequestsLoading extends AdminPendingRequestsState {}

class AdminPendingRequestsLoaded extends AdminPendingRequestsState {
  final List<FamilyUserEntity> requests;
  final FamilyEntity? family;
  const AdminPendingRequestsLoaded({required this.requests, this.family});
}

class AdminRequestApprovedSuccess extends AdminPendingRequestsState {
  final int requestId;
  const AdminRequestApprovedSuccess({required this.requestId});
}

class AdminRequestRejectedSuccess extends AdminPendingRequestsState {
  final int requestId;
  const AdminRequestRejectedSuccess({required this.requestId});
}

class AdminPendingRequestsFailure extends AdminPendingRequestsState {
  final String message;
  const AdminPendingRequestsFailure({required this.message});
}
