part of 'admin_transfer_ownership_bloc.dart';

abstract class AdminTransferOwnershipState {
  const AdminTransferOwnershipState();
}

class AdminTransferOwnershipInitial extends AdminTransferOwnershipState {}

class AdminTransferOwnershipLoading extends AdminTransferOwnershipState {}

class AdminTransferOwnershipLoaded extends AdminTransferOwnershipState {
  const AdminTransferOwnershipLoaded({required this.candidates});
  final List<FamilyUserEntity> candidates;
}

class AdminTransferOwnershipSubmitting extends AdminTransferOwnershipState {}

class AdminTransferOwnershipSuccess extends AdminTransferOwnershipState {}

class AdminTransferOwnershipFailure extends AdminTransferOwnershipState {
  const AdminTransferOwnershipFailure({required this.message});
  final String message;
}
