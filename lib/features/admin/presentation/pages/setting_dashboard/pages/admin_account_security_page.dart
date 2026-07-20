import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:dio/dio.dart';
import '../../../../../../core/network/dio_client.dart';
import '../../../../../../core/constants/app_constants.dart';
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
            AppSnackBar.success(context, AppLocalizations.of(context)!.changePasswordSuccess);
            Navigator.pop(context);
          } else {
            final msg =
                response.data['message'] ?? AppLocalizations.of(context)!.passwordChangeFailed;
            AppSnackBar.error(context, msg);
          }
        }
      } on DioException catch (e) {
        if (mounted) {
          setState(() => _isSaving = false);
          final errorMsg = e.response?.data['message'] ?? AppLocalizations.of(context)!.serverConnectionError;
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
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.surface.withValues(alpha: 0.82),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: context.primary.withValues(alpha: 0.12),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: context.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
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
                  ),
                  Divider(
                    height: 1,
                    thickness: 0.5,
                    color: context.primary.withValues(alpha: 0.12),
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
                              AppValidators.validateStrongPassword(context, val),
                        ),
                        const SizedBox(height: 12),
                        AppOutlineTextField(
                          controller: _confirmPasswordController,
                          label: l10n.confirmNewPasswordLabel,
                          hintText: l10n.confirmNewPasswordHint,
                          obscureText: true,
                          prefixIcon: Icon(LucideIcons.checkSquare,
                              color: context.primary),
                          validator: (val) => AppValidators.validateConfirmPassword(
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
                          size: AppButtonSize.large,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
