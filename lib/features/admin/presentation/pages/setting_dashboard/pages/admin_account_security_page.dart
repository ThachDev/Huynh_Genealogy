import 'package:flutter/material.dart';
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
    final confirmed = await AppDialog.confirm(
      context,
      title: l10n.deleteAccountTitle,
      message: l10n.deleteAccountConfirmMessage,
      confirmLabel: l10n.deleteAccountButton,
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
      appBar: AppAppBar(title: l10n.accountSecurityTitle),
      body: AppBackgroundBody(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Form(
            key: _formKey,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 32,
                              height: 32,
                              child: Icon(
                                LucideIcons.lock,
                                size: 16,
                                color: context.primary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              l10n.changePasswordTitle,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: context.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          l10n.passwordRequirementsDesc,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 11,
                            color: context.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        AppOutlineTextField(
                          controller: _currentPasswordController,
                          label: l10n.currentPasswordLabel,
                          hintText: l10n.currentPasswordHint,
                          obscureText: true,
                          prefixIcon:
                              Icon(LucideIcons.lock, color: context.primary),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return l10n.currentPasswordRequired;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        AppOutlineTextField(
                          controller: _newPasswordController,
                          label: l10n.newPasswordLabel,
                          hintText: l10n.newPasswordHint,
                          obscureText: true,
                          prefixIcon:
                              Icon(LucideIcons.key, color: context.primary),
                          validator: (val) =>
                              AppValidators.validateStrongPassword(
                                  context, val),
                        ),
                        const SizedBox(height: 12),
                        AppOutlineTextField(
                          controller: _confirmPasswordController,
                          label: l10n.confirmNewPasswordLabel,
                          hintText: l10n.confirmNewPasswordHint,
                          obscureText: true,
                          prefixIcon: Icon(LucideIcons.checkSquare,
                              color: context.primary),
                          validator: (val) =>
                              AppValidators.validateConfirmPassword(
                            context,
                            val,
                            _newPasswordController.text,
                          ),
                        ),
                        const SizedBox(height: 20),
                        AppButton(
                          label: l10n.updatePasswordButton,
                          onPressed: _updatePassword,
                          isLoading: _isSaving,
                          fullWidth: true,
                          size: AppButtonSize.medium,
                        ),
                      ],
                    ),
                  ),

                  // ─── KHU VỰC NGUY HIỂM ───────────────────────────────────
                  const SizedBox(height: 32),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.35),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(LucideIcons.alertTriangle,
                                size: 16, color: AppColors.error),
                            const SizedBox(width: 8),
                            Text(
                              l10n.dangerZoneTitle,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.dangerZoneDesc,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 12,
                            color: AppColors.error.withValues(alpha: 0.85),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 14),
                        AppButton(
                          label: l10n.deleteAccountButton,
                          onPressed: _isDeleting ? null : _deleteAccount,
                          variant: AppButtonVariant.danger,
                          isLoading: _isDeleting,
                          fullWidth: true,
                          prefixIcon: const Icon(
                            LucideIcons.trash2,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
