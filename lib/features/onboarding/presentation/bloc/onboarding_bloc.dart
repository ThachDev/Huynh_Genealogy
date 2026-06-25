import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/family_entity.dart';
import '../../../user/domain/entity/member_entity.dart';
import '../../../admin/domain/usecase/approve_request.dart';
import '../../domain/usecase/create_family.dart';
import '../../../admin/domain/usecase/get_pending_requests.dart';
import '../../domain/usecase/join_family.dart';
import '../../domain/usecase/verify_invite_code.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final CreateFamily createFamily;
  final VerifyInviteCode verifyInviteCode;
  final JoinFamily joinFamily;
  final GetPendingRequests getPendingRequests;
  final ApproveRequest approveRequest;

  OnboardingBloc({
    required this.createFamily,
    required this.verifyInviteCode,
    required this.joinFamily,
    required this.getPendingRequests,
    required this.approveRequest,
  }) : super(OnboardingInitial()) {
    on<CreateFamilyEvent>(_onCreateFamily);
    on<VerifyInviteCodeEvent>(_onVerifyInviteCode);
    on<JoinFamilyEvent>(_onJoinFamily);
    on<LoadPendingRequestsEvent>(_onLoadPendingRequests);
    on<ApproveRequestEvent>(_onApproveRequest);
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
        coverImageUrl: event.coverImageUrl,
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
      ),
    );
    failureOrRequest.fold(
      (failure) => emit(OnboardingFailureState(message: failure.message)),
      (request) => emit(JoinRequestSentState(request: request)),
    );
  }

  Future<void> _onLoadPendingRequests(
    LoadPendingRequestsEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(OnboardingLoading());
    final failureOrRequests = await getPendingRequests(event.familyId);
    failureOrRequests.fold(
      (failure) => emit(OnboardingFailureState(message: failure.message)),
      (requests) => emit(PendingRequestsLoadedState(requests: requests)),
    );
  }

  Future<void> _onApproveRequest(
    ApproveRequestEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(OnboardingLoading());
    final failureOrSuccess = await approveRequest(event.requestId);
    failureOrSuccess.fold(
      (failure) => emit(OnboardingFailureState(message: failure.message)),
      (success) {
        if (success) {
          emit(RequestApprovedState(requestId: event.requestId));
        } else {
          emit(const OnboardingFailureState(message: 'Phê duyệt thất bại'));
        }
      },
    );
  }
}
