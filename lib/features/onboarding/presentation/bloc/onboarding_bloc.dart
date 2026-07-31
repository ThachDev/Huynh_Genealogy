import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/domain/entity/family_entity.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import '../../domain/usecase/create_family.dart';
import '../../domain/usecase/join_family.dart';
import '../../domain/usecase/verify_invite_code.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final CreateFamily createFamily;
  final VerifyInviteCode verifyInviteCode;
  final JoinFamily joinFamily;

  OnboardingBloc({
    required this.createFamily,
    required this.verifyInviteCode,
    required this.joinFamily,
  }) : super(OnboardingInitial()) {
    on<CreateFamilyEvent>(_onCreateFamily);
    on<VerifyInviteCodeEvent>(_onVerifyInviteCode);
    on<JoinFamilyEvent>(_onJoinFamily);
  }

  Future<void> _onCreateFamily(
    CreateFamilyEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(OnboardingLoading());
    final failureOrFamily = await createFamily(
      CreateFamilyParams(
        name: event.name,
        description: event.description,
        logoUrl: event.logoUrl,
        userId: event.userId,
      ),
    );
    failureOrFamily.fold(
      (failure) => emit(OnboardingFailureState(message: failure.message)),
      (family) => emit(FamilyCreatedState(family: family)),
    );
  }

  Future<void> _onVerifyInviteCode(
    VerifyInviteCodeEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(OnboardingLoading());
    final failureOrMap = await verifyInviteCode(event.code);
    failureOrMap.fold(
      (failure) => emit(OnboardingFailureState(message: failure.message)),
      (map) {
        final family = map['family'] as FamilyEntity;
        final members = map['members'] as List<MemberEntity>;
        emit(InviteCodeVerifiedState(family: family, members: members));
      },
    );
  }

  Future<void> _onJoinFamily(
    JoinFamilyEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(OnboardingLoading());
    final failureOrRequest = await joinFamily(
      JoinFamilyParams(
        userId: event.userId,
        familyId: event.familyId,
        memberNodeId: event.memberNodeId,
        fullName: event.fullName,
        gender: event.gender,
        dateOfBirth: event.dateOfBirth,
        placeOfBirth: event.placeOfBirth,
        maritalStatus: event.maritalStatus,
        education: event.education,
        avatarUrl: event.avatarUrl,
        parentId: event.parentId,
        spouseId: event.spouseId,
        notes: event.notes,
      ),
    );
    failureOrRequest.fold(
      (failure) => emit(OnboardingFailureState(message: failure.message)),
      (request) => emit(JoinRequestSentState(request: request)),
    );
  }
}
