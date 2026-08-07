part of 'member_trash_bloc.dart';

abstract class MemberTrashEvent extends Equatable {
  const MemberTrashEvent();

  @override
  List<Object?> get props => [];
}

class LoadMemberTrashEvent extends MemberTrashEvent {
  final int? familyId;
  final int? branchId;

  const LoadMemberTrashEvent({this.familyId, this.branchId});

  @override
  List<Object?> get props => [familyId, branchId];
}

class RestoreMemberEvent extends MemberTrashEvent {
  final int memberId;

  const RestoreMemberEvent(this.memberId);

  @override
  List<Object?> get props => [memberId];
}

class PurgeTrashEvent extends MemberTrashEvent {
  final int days;

  const PurgeTrashEvent({this.days = 30});

  @override
  List<Object?> get props => [days];
}

class RestoreSuccessEvent extends MemberTrashEvent {
  final MemberEntity member;

  const RestoreSuccessEvent(this.member);

  @override
  List<Object?> get props => [member];
}