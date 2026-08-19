import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/auth.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_state.dart';
import '../widgets/path_selection_widget.dart';
import '../widgets/creator_onboarding_widget.dart';
import '../widgets/viewer_onboarding_widget.dart';
import '../widgets/pending_approval_widget.dart';
import '../widgets/family_creation_success_dialog.dart';

/// ============================================================================
/// PRESENTATION LAYER — ONBOARDING PAGE (MAIN SCREEN)
/// ============================================================================
/// Màn hình chính điều hướng người dùng chưa thuộc dòng họ nào thực hiện Onboarding.
///
/// Các luồng Onboarding chính:
///   1. Lựa chọn vai trò (PathSelectionWidget):
///      - Luồng 1: Người tạo dòng họ mới (Creator - Trưởng tộc/Người lập gia phả).
///      - Luồng 2: Thành viên tham gia vào dòng họ đã có (Viewer - Nhập mã mời).
///   2. Đang chờ duyệt (PendingApprovalWidget): Người dùng đã gửi yêu cầu gia nhập và chờ duyệt.
///
/// Tích hợp BLoC với `BlocConsumer<OnboardingBloc, OnboardingState>`:
///   - `listener`: Xử lý Side-effects một lần (Hiển thị Dialog thành công, Toast thông báo lỗi).
///   - `builder`: Dựng (Render) giao diện dựa theo State hoặc State nội bộ màn hình.
/// ============================================================================
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  // State nội bộ của UI để quản lý nhánh màn hình hiển thị
  bool _isRequestSent = false;
  int? _joinedFamilyId;
  int? _selectedPath; // null = Màn hình chọn vai trò, 1 = Creator, 2 = Viewer

  @override
  Widget build(BuildContext context) {
    // Đọc trạng thái xác thực từ AuthBloc
    final authState = context.watch<AuthBloc>().state;
    if (authState is! Authenticated) {
      return const Scaffold(
        body: Center(
          child: AppLoading(size: 80),
        ),
      );
    }

    final user = authState.user;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppAppBar(
        title: l10n.onboardingTitle,
        // Nút quay lại màn hình chọn vai trò nếu đang ở giao diện điền thông tin
        leading: (_selectedPath != null && !_isRequestSent)
            ? IconButton(
                icon: Icon(LucideIcons.arrowLeft, color: context.textPrimary),
                onPressed: () {
                  setState(() {
                    _selectedPath = null;
                  });
                },
              )
            : null,
        actions: [
          if (_selectedPath == null)
            IconButton(
              icon: Icon(LucideIcons.logOut, color: context.textPrimary),
              tooltip: l10n.logoutLabel,
              onPressed: () {
                // Đăng xuất ứng dụng từ AuthBloc
                context.read<AuthBloc>().add(AuthLogoutRequested());
              },
            ),
        ],
      ),
      body: AppBackgroundBody(
        // ---------------------------------------------------------------------
        // BlocConsumer: Kết hợp cả Listener (Side-effects) & Builder (Render UI)
        // ---------------------------------------------------------------------
        child: BlocConsumer<OnboardingBloc, OnboardingState>(
          // 1. LISTENER — Lắng nghe biến đổi State để thực hiện tác vụ phụ (Hiển thị SnackBar / Dialog)
          listener: (context, state) {
            if (state is OnboardingFailureState) {
              // Hiển thị lỗi khi gọi API tạo dòng họ / xác minh / gửi yêu cầu thất bại
              AppSnackBar.error(context, state.message);
            } else if (state is FamilyCreatedState) {
              // Tạo dòng họ thành công -> Hiển thị Dialog chúc mừng & cập nhật User sang vai trò OWNER
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (dialogCtx) => FamilyCreationSuccessDialog(
                  family: state.family,
                  onProceed: () {
                    final updatedUser = user.copyWith(
                      familyId: state.family.id,
                      role: 'OWNER',
                    );
                    UserMainNavigationPage.setAdminMode(true,
                        userId: user.id);
                    context
                        .read<AuthBloc>()
                        .add(AuthUserUpdated(user: updatedUser));
                  },
                ),
              );
            } else if (state is InviteCodeVerifiedState) {
              // Mã mời hợp lệ -> Thông báo cho người dùng
              AppSnackBar.success(
                context,
                l10n.verifyInviteSuccess(state.family.name),
              );
            } else if (state is JoinRequestSentState) {
              // Gửi yêu cầu gia nhập thành công -> Chuyển màn hình sang trạng thái Chờ phê duyệt (Pending)
              AppSnackBar.success(context, l10n.joinRequestSuccess);
              setState(() {
                _isRequestSent = true;
                _joinedFamilyId = state.request.familyId;
              });
            }
          },
          // 2. BUILDER — Trả về Widget đại diện cho giao diện hiện tại
          builder: (context, state) {
            final isPending = user.pendingStatus == 'PENDING';
            final targetFamilyId =
                _joinedFamilyId ?? user.familyId ?? user.pendingFamilyId;
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Trường hợp 1: Đã gửi yêu cầu hoặc đang ở trạng thái PENDING -> Hiện màn hình Chờ duyệt
                  if (_isRequestSent || isPending || targetFamilyId != null)
                    PendingApprovalWidget(
                      user: user,
                      familyId: targetFamilyId,
                    )
                  // Trường hợp 2: Chưa chọn luồng -> Hiện màn hình Lựa chọn vai trò (Creator vs Viewer)
                  else if (_selectedPath == null)
                    PathSelectionWidget(
                      user: user,
                      selectedPath: _selectedPath,
                      onPathSelected: (path) {
                        setState(() {
                          _selectedPath = path;
                        });
                      },
                    )
                  // Trường hợp 3: Luồng 1 (Creator) -> Màn hình Đăng ký tạo Dòng họ
                  else if (_selectedPath == 1)
                    CreatorOnboardingWidget(user: user)
                  // Trường hợp 4: Luồng 2 (Viewer) -> Màn hình Xác minh mã mời & Đăng ký thành viên
                  else
                    ViewerOnboardingWidget(user: user),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

