part of 'admin_transfer_ownership_bloc.dart';

abstract class AdminTransferOwnershipEvent {}

class LoadCandidatesEvent extends AdminTransferOwnershipEvent {
  final int familyId;
  LoadCandidatesEvent({required this.familyId});
}

class TransferOwnershipEvent extends AdminTransferOwnershipEvent {
  final int familyId;
  final int newOwnerUserId;
  TransferOwnershipEvent({
    required this.familyId,
    required this.newOwnerUserId,
  });
}
