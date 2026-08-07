part of 'member_account_links_bloc.dart';

abstract class MemberAccountLinksEvent extends Equatable {
  const MemberAccountLinksEvent();

  @override
  List<Object?> get props => [];
}

class LoadMemberAccountLinksEvent extends MemberAccountLinksEvent {
  const LoadMemberAccountLinksEvent({required this.familyId});

  final int familyId;

  @override
  List<Object?> get props => [familyId];
}

class LinkMemberEmailEvent extends MemberAccountLinksEvent {
  const LinkMemberEmailEvent({
    required this.familyId,
    required this.memberId,
    required this.email,
  });

  final int familyId;
  final int memberId;
  final String email;

  @override
  List<Object?> get props => [familyId, memberId, email];
}

class UnlinkMemberAccountEvent extends MemberAccountLinksEvent {
  const UnlinkMemberAccountEvent({
    required this.familyId,
    required this.memberId,
  });

  final int familyId;
  final int memberId;

  @override
  List<Object?> get props => [familyId, memberId];
}