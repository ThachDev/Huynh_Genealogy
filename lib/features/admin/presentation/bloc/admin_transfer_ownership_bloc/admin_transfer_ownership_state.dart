part of 'admin_transfer_ownership_bloc.dart';

abstract class AdminTransferOwnershipState {
  const AdminTransferOwnershipState();
}

class AdminTransferOwnershipInitial extends AdminTransferOwnershipState {}

class AdminTransferOwnershipLoading extends AdminTransferOwnershipState {}

class AdminTransferOwnershipLoaded extends AdminTransferOwnershipState {
  final List<FamilyUserEntity> candidates;
  const AdminTransferOwnershipLoaded({required this.candidates});
}

class AdminTransferOwnershipSubmitting extends AdminTransferOwnershipState {}

class AdminTransferOwnershipSuccess extends AdminTransferOwnershipState {}

class AdminTransferOwnershipFailure extends AdminTransferOwnershipState {
  final String message;
  const AdminTransferOwnershipFailure({required this.message});
}
