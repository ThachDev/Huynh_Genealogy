part of 'admin_pending_requests_bloc.dart';

abstract class AdminPendingRequestsEvent {}

class LoadAdminPendingRequestsEvent extends AdminPendingRequestsEvent {
  final int familyId;
  LoadAdminPendingRequestsEvent({required this.familyId});
}

class ApproveAdminRequestEvent extends AdminPendingRequestsEvent {
  final int requestId;
  ApproveAdminRequestEvent({required this.requestId});
}

class RejectAdminRequestEvent extends AdminPendingRequestsEvent {
  final int requestId;
  RejectAdminRequestEvent({required this.requestId});
}
