part of 'member_trash_bloc.dart';

abstract class MemberTrashEvent extends Equatable {
  const MemberTrashEvent();

  @override
  List<Object?> get props => [];
}

class LoadMemberTrashEvent extends MemberTrashEvent {

  const LoadMemberTrashEvent({this.familyId, this.branchId});
  final int? familyId;
  final int? branchId;

  @override
  List<Object?> get props => [familyId, branchId];
}

class RestoreMemberEvent extends MemberTrashEvent {

  const RestoreMemberEvent(this.memberId);
  final int memberId;

  @override
  List<Object?> get props => [memberId];
}

class DeletePermanentlyMemberEvent extends MemberTrashEvent {

  const DeletePermanentlyMemberEvent(this.memberId);
  final int memberId;

  @override
  List<Object?> get props => [memberId];
}

class PurgeTrashEvent extends MemberTrashEvent {

  const PurgeTrashEvent({this.days = 0});
  final int days;

  @override
  List<Object?> get props => [days];
}

class RestoreSuccessEvent extends MemberTrashEvent {

  const RestoreSuccessEvent(this.member);
  final MemberEntity member;

  @override
  List<Object?> get props => [member];
}