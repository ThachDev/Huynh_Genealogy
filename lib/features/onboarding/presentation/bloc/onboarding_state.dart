import 'package:equatable/equatable.dart';
import '../../domain/entity/family_entity.dart';
import '../../domain/entity/family_user_entity.dart';
import '../../../user/domain/entity/member_entity.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboardingLoading extends OnboardingState {}

class FamilyCreatedState extends OnboardingState {
  final FamilyEntity family;

  const FamilyCreatedState({required this.family});

  @override
  List<Object?> get props => [family];
}

class InviteCodeVerifiedState extends OnboardingState {
  final FamilyEntity family;
  final List<MemberEntity> members;

  const InviteCodeVerifiedState({
    required this.family,
    required this.members,
  });

  @override
  List<Object?> get props => [family, members];
}

class JoinRequestSentState extends OnboardingState {
  final FamilyUserEntity request;

  const JoinRequestSentState({required this.request});

  @override
  List<Object?> get props => [request];
}

class PendingRequestsLoadedState extends OnboardingState {
  final List<FamilyUserEntity> requests;

  const PendingRequestsLoadedState({required this.requests});

  @override
  List<Object?> get props => [requests];
}

class RequestApprovedState extends OnboardingState {
  final int requestId;

  const RequestApprovedState({required this.requestId});

  @override
  List<Object?> get props => [requestId];
}

class OnboardingFailureState extends OnboardingState {
  final String message;

  const OnboardingFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}
