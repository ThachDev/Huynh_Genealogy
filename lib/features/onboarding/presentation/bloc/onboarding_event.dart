import 'package:equatable/equatable.dart';

/// ============================================================================
/// BLOC EVENTS — ONBOARDING FEATURE
/// ============================================================================
/// Events đại diện cho các hành động/sự kiện từ phía người dùng (User Actions)
/// hoặc hệ thống phát ra để yêu cầu BLoC xử lý.
///
/// Sử dụng `Equatable` để giúp BLoC so sánh giá trị của Event (value equality)
/// thay vì so sánh tham chiếu bộ nhớ (reference equality).
/// ============================================================================
abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

/// ----------------------------------------------------------------------------
/// Event 1: Tạo dòng họ mới (Dành cho Người tạo / Creator / Trưởng tộc)
/// ----------------------------------------------------------------------------
class CreateFamilyEvent extends OnboardingEvent {

  const CreateFamilyEvent({
    required this.name,
    this.description,
    this.logoUrl,
    required this.userId,
  });
  final String name;
  final String? description;
  final String? logoUrl;
  final int userId;

  @override
  List<Object?> get props => [name, description, logoUrl, userId];
}

/// ----------------------------------------------------------------------------
/// Event 2: Xác nhận Mã mời gia nhập dòng họ (Verify Invite Code)
/// ----------------------------------------------------------------------------
class VerifyInviteCodeEvent extends OnboardingEvent {

  const VerifyInviteCodeEvent({required this.code});
  final String code;

  @override
  List<Object?> get props => [code];
}

/// ----------------------------------------------------------------------------
/// Event 3: Gửi yêu cầu gia nhập dòng họ (Join Family Request)
/// Người dùng có thể chọn gán vào vị trí thành viên có sẵn (memberNodeId)
/// hoặc đăng ký mới với thông tin cá nhân/quan hệ gia đình.
/// ----------------------------------------------------------------------------
class JoinFamilyEvent extends OnboardingEvent {

  const JoinFamilyEvent({
    required this.userId,
    required this.familyId,
    this.memberNodeId,
    this.fullName,
    this.gender,
    this.dateOfBirth,
    this.placeOfBirth,
    this.maritalStatus,
    this.education,
    this.avatarUrl,
    this.parentId,
    this.spouseId,
    this.notes,
  });
  final int userId;
  final int familyId;
  final int? memberNodeId;
  final String? fullName;
  final String? gender;
  final String? dateOfBirth;
  final String? placeOfBirth;
  final String? maritalStatus;
  final String? education;
  final String? avatarUrl;
  final int? parentId;
  final int? spouseId;
  final String? notes;

  @override
  List<Object?> get props => [
        userId,
        familyId,
        memberNodeId,
        fullName,
        gender,
        dateOfBirth,
        placeOfBirth,
        maritalStatus,
        education,
        avatarUrl,
        notes,
      ];
}

