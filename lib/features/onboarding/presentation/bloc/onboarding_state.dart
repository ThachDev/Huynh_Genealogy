import 'package:equatable/equatable.dart';
import '../../../family_tree/domain/entities/family_entity.dart';
import '../../../../core/domain/entity/family_user_entity.dart';
import 'package:giatocviet/features/family_tree/domain/entities/member_entity.dart';

/// ============================================================================
/// BLOC STATES — ONBOARDING FEATURE
/// ============================================================================
/// States đại diện cho các trạng thái của giao diện (UI States) phản hồi theo Event.
/// UI sẽ lắng nghe (listen) hoặc xây dựng (build) lại dựa trên State hiện tại.
/// ============================================================================
abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

/// 1. Trạng thái ban đầu (Chưa gửi hành động nào)
class OnboardingInitial extends OnboardingState {}

/// 2. Trạng thái Đang tải (Đang gọi API tạo dòng họ / xác minh mã / gửi yêu cầu)
class OnboardingLoading extends OnboardingState {}

/// 3. Trạng thái Tạo dòng họ thành công -> Chứa thông tin Dòng họ mới tạo (`FamilyEntity`)
class FamilyCreatedState extends OnboardingState {

  const FamilyCreatedState({required this.family});
  final FamilyEntity family;

  @override
  List<Object?> get props => [family];
}

/// 4. Trạng thái Xác minh mã mời thành công -> Chứa thông tin Dòng họ & Danh sách thành viên gia phả
class InviteCodeVerifiedState extends OnboardingState {

  const InviteCodeVerifiedState({
    required this.family,
    required this.members,
  });
  final FamilyEntity family;
  final List<MemberEntity> members;

  @override
  List<Object?> get props => [family, members];
}

/// 5. Trạng thái Gửi yêu cầu gia nhập thành công -> Chứa thông tin Yêu cầu (`FamilyUserEntity`)
class JoinRequestSentState extends OnboardingState {

  const JoinRequestSentState({required this.request});
  final FamilyUserEntity request;

  @override
  List<Object?> get props => [request];
}

/// 6. Trạng thái Thất bại -> Chứa thông báo lỗi để hiển thị SnackBar/Toast cho người dùng
class OnboardingFailureState extends OnboardingState {

  const OnboardingFailureState({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}

