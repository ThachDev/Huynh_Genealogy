import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/domain/entity/family_entity.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import '../../domain/usecase/create_family.dart';
import '../../domain/usecase/join_family.dart';
import '../../domain/usecase/verify_invite_code.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

/// ============================================================================
/// BLOC — ONBOARDING FEATURE (State Management & Business Logic)
/// ============================================================================
/// OnboardingBloc đóng vai trò trung gian giữa Presentation Layer (UI) và Domain Layer (UseCases).
///
/// Luồng hoạt động (Data & State Flow):
///   1. UI phát ra `OnboardingEvent` (vd: `CreateFamilyEvent`).
///   2. BLoC nhận Event, phát ra `OnboardingLoading()` để UI hiển thị Loading indicator.
///   3. BLoC gọi UseCase thích hợp (vd: `createFamily(params)`).
///   4. UseCase trả về `Either<Failure, SuccessData>` từ dartz package.
///   5. BLoC dùng hàm `.fold()`:
///      - Bên Trái (Left - Failure): Phát ra `OnboardingFailureState(message)`.
///      - Bên Phải (Right - Success): Phát ra State tương ứng (`FamilyCreatedState`, v.v.).
///   6. UI lắng nghe State mới và tự động cập nhật / điều hướng màn hình.
/// ============================================================================
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final CreateFamily createFamily;
  final VerifyInviteCode verifyInviteCode;
  final JoinFamily joinFamily;

  OnboardingBloc({
    required this.createFamily,
    required this.verifyInviteCode,
    required this.joinFamily,
  }) : super(OnboardingInitial()) {
    // Đăng ký các Event Handlers với BLoC
    on<CreateFamilyEvent>(_onCreateFamily);
    on<VerifyInviteCodeEvent>(_onVerifyInviteCode);
    on<JoinFamilyEvent>(_onJoinFamily);
  }

  /// --------------------------------------------------------------------------
  /// Xử lý Event 1: Tạo Dòng họ mới
  /// --------------------------------------------------------------------------
  Future<void> _onCreateFamily(
    CreateFamilyEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(OnboardingLoading()); // 1. Báo UI là đang xử lý
    final failureOrFamily = await createFamily(
      CreateFamilyParams(
        name: event.name,
        description: event.description,
        logoUrl: event.logoUrl,
        userId: event.userId,
      ),
    );
    // 2. Phân nhánh kết quả theo Pattern Either (Left = Lỗi, Right = Thành công)
    failureOrFamily.fold(
      (failure) => emit(OnboardingFailureState(message: failure.message)),
      (family) => emit(FamilyCreatedState(family: family)),
    );
  }

  /// --------------------------------------------------------------------------
  /// Xử lý Event 2: Xác nhận Mã mời gia nhập dòng họ
  /// --------------------------------------------------------------------------
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

  /// --------------------------------------------------------------------------
  /// Xử lý Event 3: Gửi yêu cầu gia nhập dòng họ
  /// --------------------------------------------------------------------------
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

