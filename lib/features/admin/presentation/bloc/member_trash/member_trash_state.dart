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

  const MemberTrashLoaded({required this.members});
  final List<MemberEntity> members;

  @override
  List<Object?> get props => [members];
}

class MemberTrashFailure extends MemberTrashState {

  const MemberTrashFailure({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}

class MemberRestoredState extends MemberTrashState {

  const MemberRestoredState({required this.member});
  final MemberEntity member;

  @override
  List<Object?> get props => [member];
}

class TrashPurgedState extends MemberTrashState {

  const TrashPurgedState({required this.removed});
  final int removed;

  @override
  List<Object?> get props => [removed];
}