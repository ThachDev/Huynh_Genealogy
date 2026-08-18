import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:dio/dio.dart';
import '../../../../../../core/network/dio_client.dart';
import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../../../../resources/app_localizations.dart';
import '../../../../../../features/auth/auth.dart';
import '../../admin_dashboard/pages/admin_link_and_roles_page.dart';

class AdminAccountSecurityPage extends StatefulWidget {
  const AdminAccountSecurityPage({super.key});

  @override
  State<AdminAccountSecurityPage> createState() =>
      _AdminAccountSecurityPageState();
}

class _AdminAccountSecurityPageState extends State<AdminAccountSecurityPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isSaving = false;
  bool _isDeleting = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePassword() async {
    if (_formKey.currentState!.validate()) {
      final l10n = AppLocalizations.of(context)!;
      setState(() => _isSaving = true);
      try {
        final fbUser = fb.FirebaseAuth.instance.currentUser;
        if (fbUser == null) {
          throw Exception(l10n.notLoggedIn);
        }

        final idToken = await fbUser.getIdToken();
        if (idToken == null) {
          throw Exception(l10n.sessionTokenError);
        }

        final response = await DioClient.instance.post(
          AppConstants.changePasswordEndpoint,
          data: {
            'idToken': idToken,
            'currentPassword': _currentPasswordController.text,
            'newPassword': _newPasswordController.text,
          },
        );

        if (mounted) {
          setState(() => _isSaving = false);
          if (response.statusCode == 200 && response.data['success'] == true) {
            AppSnackBar.success(
                context, AppLocalizations.of(context)!.changePasswordSuccess);
            Navigator.pop(context);
          } else {
            final msg = response.data['message'] ??
                AppLocalizations.of(context)!.passwordChangeFailed;
            AppSnackBar.error(context, msg);
          }
        }
      } on DioException catch (e) {
        if (mounted) {
          setState(() => _isSaving = false);
          final errorMsg = e.response?.data['message'] ??
              AppLocalizations.of(context)!.serverConnectionError;
          AppSnackBar.error(context, errorMsg);
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isSaving = false);
          AppSnackBar.error(
              context, e.toString().replaceAll('Exception: ', ''));
        }
      }
    }
  }

  Future<void> _deleteAccount() async {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.read<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;
    final role = (user?.role ?? '').toUpperCase();
    final isOwner = role == 'OWNER' || role == 'CREATOR';

    // ── 1. Ràng buộc nếu là Trưởng tộc / Chủ sở hữu dòng tộc ──
    if (isOwner && user?.familyId != null && user!.familyId! > 0) {
      final shouldGoToTransfer = await AppDialog.confirm(
        context,
        title: 'Chưa thể xóa tài khoản',
        message:
            'Bạn đang giữ vai trò Trưởng tộc của dòng họ. Để đảm bảo an toàn cho dữ liệu dòng tộc, bạn cần chuyển nhượng quyền Trưởng tộc cho thành viên khác trước khi xóa tài khoản.',
        confirmLabel: 'Chuyển nhượng quyền',
        cancelLabel: 'Đã hiểu',
        type: AppDialogType.warning,
      );

      if (shouldGoToTransfer == true && mounted) {
        Navigator.push(
          context,
          SereneFadeSlidePageRoute(
            page: const AdminLinkAndRolesPage(initialTabIndex: 1),
          ),
        );
      }
      return;
    }

    // ── 2. Xác nhận bảo mật 2 bước: Bắt buộc nhập chữ xác nhận ──
    final confirmed = await AppDialog.confirmWithInput(
      context,
      title: 'Xóa tài khoản vĩnh viễn',
      message:
          'Toàn bộ thông tin cá nhân, quyền hạn và liên kết gia phả của bạn sẽ bị xóa vĩnh viễn không thể khôi phục.',
      requiredWord: 'XÓA TÀI KHOẢN',
      inputInstruction: 'Nhập chính xác cụm từ "XÓA TÀI KHOẢN" để xác nhận:',
      confirmLabel: 'Xác nhận xóa',
      cancelLabel: l10n.cancelLabel,
      type: AppDialogType.danger,
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isDeleting = true);
    try {
      final response = await DioClient.instance.delete(
        AppConstants.deleteAccountEndpoint,
      );
      if (!mounted) return;
      if (response.statusCode == 200 && response.data['success'] == true) {
        await fb.FirebaseAuth.instance.signOut();
        if (mounted) {
          AppSnackBar.success(context, l10n.deleteAccountSuccess);
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } else {
        final msg = response.data['message'] ?? l10n.deleteAccountFailed;
        AppSnackBar.error(context, msg);
      }
    } on DioException catch (e) {
      if (mounted) {
        final msg = e.response?.data['message'] ?? l10n.serverConnectionError;
        AppSnackBar.error(context, msg);
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(context, e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.background,
      appBar: AppAppBar(
        title: l10n.accountSecurityTitle,
        transparent: false,
      ),
      body: AppBackgroundBody(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 52,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ── Phần trên: Form Đổi Mật Khẩu ──
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── 1. Đổi mật khẩu Section Header ──
                          Row(
                            children: [
                              Icon(LucideIcons.lock,
                                  size: 20, color: context.primary),
                              const SizedBox(width: 8),
                              Text(
                                l10n.changePasswordTitle,
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: context.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.passwordRequirementsDesc,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 12.5,
                              color: context.textSecondary,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ── Mật khẩu hiện tại ──
                          AppOutlineTextField(
                            controller: _currentPasswordController,
                            label: l10n.currentPasswordLabel,
                            hintText: l10n.currentPasswordHint,
                            obscureText: _obscureCurrent,
                            prefixIcon: Icon(LucideIcons.lock,
                                color: context.primary, size: 18),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureCurrent
                                    ? LucideIcons.eyeOff
                                    : LucideIcons.eye,
                                size: 18,
                                color: context.textSecondary,
                              ),
                              onPressed: () => setState(
                                  () => _obscureCurrent = !_obscureCurrent),
                            ),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return l10n.currentPasswordRequired;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),

                          // ── Mật khẩu mới ──
                          AppOutlineTextField(
                            controller: _newPasswordController,
                            label: l10n.newPasswordLabel,
                            hintText: l10n.newPasswordHint,
                            obscureText: _obscureNew,
                            prefixIcon: Icon(LucideIcons.key,
                                color: context.primary, size: 18),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureNew
                                    ? LucideIcons.eyeOff
                                    : LucideIcons.eye,
                                size: 18,
                                color: context.textSecondary,
                              ),
                              onPressed: () =>
                                  setState(() => _obscureNew = !_obscureNew),
                            ),
                            validator: (val) =>
                                AppValidators.validateStrongPassword(
                                    context, val),
                          ),
                          const SizedBox(height: 14),

                          // ── Xác nhận mật khẩu mới ──
                          AppOutlineTextField(
                            controller: _confirmPasswordController,
                            label: l10n.confirmNewPasswordLabel,
                            hintText: l10n.confirmNewPasswordHint,
                            obscureText: _obscureConfirm,
                            prefixIcon: Icon(LucideIcons.checkSquare,
                                color: context.primary, size: 18),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirm
                                    ? LucideIcons.eyeOff
                                    : LucideIcons.eye,
                                size: 18,
                                color: context.textSecondary,
                              ),
                              onPressed: () => setState(
                                  () => _obscureConfirm = !_obscureConfirm),
                            ),
                            validator: (val) =>
                                AppValidators.validateConfirmPassword(
                              context,
                              val,
                              _newPasswordController.text,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ── Button Cập Nhật Mật Khẩu ──
                          AppButton(
                            label: l10n.updatePasswordButton,
                            onPressed: _updatePassword,
                            isLoading: _isSaving,
                            fullWidth: true,
                            size: AppButtonSize.medium,
                          ),
                        ],
                      ),

                      // ── Phần dưới: Xóa tài khoản (luôn ở đáy màn hình) ──
                      Padding(
                        padding: const EdgeInsets.only(top: 36),
                        child: Column(
                          children: [
                            Center(
                              child: TextButton.icon(
                                onPressed: _isDeleting ? null : _deleteAccount,
                                icon: Icon(
                                  LucideIcons.trash2,
                                  size: 15,
                                  color: AppColors.error.withValues(alpha: 0.8),
                                ),
                                label: Text(
                                  l10n.deleteAccountButton,
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        AppColors.error.withValues(alpha: 0.8),
                                    decoration: TextDecoration.underline,
                                    decorationColor:
                                        AppColors.error.withValues(alpha: 0.4),
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  foregroundColor: AppColors.error,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Center(
                              child: Text(
                                l10n.dangerZoneDesc,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  color: context.textSecondary
                                      .withValues(alpha: 0.7),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
