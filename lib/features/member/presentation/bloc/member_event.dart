part of 'member_bloc.dart';

abstract class MemberEvent extends Equatable {
  const MemberEvent();

  @override
  List<Object?> get props => [];
}

class LoadMemberEvent extends MemberEvent {
  final int? memberId;
  const LoadMemberEvent(this.memberId);

  @override
  List<Object?> get props => [memberId];
}

class SubmitMemberEvent extends MemberEvent {
  final MemberEntity member;
  final File? imageFile;

  const SubmitMemberEvent({required this.member, this.imageFile});

  @override
  List<Object?> get props => [member, imageFile];
}

class DeleteMemberEvent extends MemberEvent {
  final int memberId;
  const DeleteMemberEvent(this.memberId);

  @override
  List<Object?> get props => [memberId];
}

class ResetMemberEvent extends MemberEvent {}
