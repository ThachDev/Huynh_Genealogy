part of 'member_trash_bloc.dart';

abstract class MemberTrashState extends Equatable {
  const MemberTrashState();

  @override
  List<Object?> get props => [];
}

class MemberTrashInitial extends MemberTrashState {
  const MemberTrashInitial();
}

class MemberTrashLoading extends MemberTrashState {
  const MemberTrashLoading();
}

class MemberTrashLoaded extends MemberTrashState {
  final List<MemberEntity> members;

  const MemberTrashLoaded({required this.members});

  @override
  List<Object?> get props => [members];
}

class MemberTrashFailure extends MemberTrashState {
  final String message;

  const MemberTrashFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class MemberRestoredState extends MemberTrashState {
  final MemberEntity member;

  const MemberRestoredState({required this.member});

  @override
  List<Object?> get props => [member];
}

class TrashPurgedState extends MemberTrashState {
  final int removed;

  const TrashPurgedState({required this.removed});

  @override
  List<Object?> get props => [removed];
}