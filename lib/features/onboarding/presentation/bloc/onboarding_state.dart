import 'package:equatable/equatable.dart';
import '../../../../core/domain/entity/family_entity.dart';
import '../../../../core/domain/entity/family_user_entity.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';

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

class OnboardingFailureState extends OnboardingState {
  final String message;

  const OnboardingFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}
