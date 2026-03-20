part of 'member_bloc.dart';

abstract class MemberState extends Equatable {
  const MemberState();

  @override
  List<Object?> get props => [];
}

class MemberInitial extends MemberState {}

class MemberLoading extends MemberState {}

class MemberReady extends MemberState {
  final MemberEntity? member;
  const MemberReady({this.member});

  @override
  List<Object?> get props => [member];
}

class MemberSubmitting extends MemberState {}

class MemberSuccess extends MemberState {
  final MemberEntity member;
  final bool isDeleted;

  const MemberSuccess({required this.member, this.isDeleted = false});

  @override
  List<Object?> get props => [member, isDeleted];
}

class MemberError extends MemberState {
  final String message;

  const MemberError(this.message);

  @override
  List<Object?> get props => [message];
}
