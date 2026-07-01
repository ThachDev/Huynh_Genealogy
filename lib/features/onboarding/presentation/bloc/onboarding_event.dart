import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class CreateFamilyEvent extends OnboardingEvent {
  final String name;
  final String? description;
  final String? logoUrl;
  final int userId;

  const CreateFamilyEvent({
    required this.name,
    this.description,
    this.logoUrl,
    required this.userId,
  });

  @override
  List<Object?> get props => [name, description, logoUrl, userId];
}

class VerifyInviteCodeEvent extends OnboardingEvent {
  final String code;

  const VerifyInviteCodeEvent({required this.code});

  @override
  List<Object?> get props => [code];
}

class JoinFamilyEvent extends OnboardingEvent {
  final int userId;
  final int familyId;
  final int? memberNodeId;

  const JoinFamilyEvent({
    required this.userId,
    required this.familyId,
    this.memberNodeId,
  });

  @override
  List<Object?> get props => [userId, familyId, memberNodeId];
}
