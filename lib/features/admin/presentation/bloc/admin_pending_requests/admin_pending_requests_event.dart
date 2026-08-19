part of 'admin_pending_requests_bloc.dart';

abstract class AdminPendingRequestsEvent {}

class LoadAdminPendingRequestsEvent extends AdminPendingRequestsEvent {
  LoadAdminPendingRequestsEvent({required this.familyId});
  final int familyId;
}

class ApproveAdminRequestEvent extends AdminPendingRequestsEvent {
  ApproveAdminRequestEvent({required this.requestId});
  final int requestId;
}

class RejectAdminRequestEvent extends AdminPendingRequestsEvent {
  RejectAdminRequestEvent({required this.requestId});
  final int requestId;
}
