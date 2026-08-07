part of 'member_account_links_bloc.dart';

abstract class MemberAccountLinksState extends Equatable {
  const MemberAccountLinksState();

  @override
  List<Object?> get props => [];
}

class MemberAccountLinksInitial extends MemberAccountLinksState {
  const MemberAccountLinksInitial();
}

class MemberAccountLinksLoading extends MemberAccountLinksState {
  const MemberAccountLinksLoading();
}

class MemberAccountLinksLoaded extends MemberAccountLinksState {
  const MemberAccountLinksLoaded({required this.items});

  final List<MemberAccountLinkEntity> items;

  @override
  List<Object?> get props => [items];
}

class MemberAccountLinksFailure extends MemberAccountLinksState {
  const MemberAccountLinksFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class MemberAccountLinkedSuccess extends MemberAccountLinksState {
  const MemberAccountLinkedSuccess({
    required this.memberId,
    required this.email,
    this.invited = false,
  });

  final int memberId;
  final String email;
  final bool invited;

  @override
  List<Object?> get props => [memberId, email, invited];
}

class MemberAccountUnlinkedSuccess extends MemberAccountLinksState {
  const MemberAccountUnlinkedSuccess({required this.memberId});

  final int memberId;

  @override
  List<Object?> get props => [memberId];
}