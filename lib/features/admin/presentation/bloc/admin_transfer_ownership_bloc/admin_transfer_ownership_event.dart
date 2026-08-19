part of 'admin_transfer_ownership_bloc.dart';

abstract class AdminTransferOwnershipEvent {}

class LoadCandidatesEvent extends AdminTransferOwnershipEvent {
  LoadCandidatesEvent({required this.familyId});
  final int familyId;
}

class TransferOwnershipEvent extends AdminTransferOwnershipEvent {
  TransferOwnershipEvent({
    required this.familyId,
    required this.newOwnerUserId,
  });
  final int familyId;
  final int newOwnerUserId;
}
