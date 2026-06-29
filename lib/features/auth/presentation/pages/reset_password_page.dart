import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordPage({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isObscureNew = true;
  bool _isObscureConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSubmitPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthResetPasswordRequested(
              email: widget.email,
              otp: widget.otp,
              newPassword: _passwordController.text,
            ),
          );
    }
  }

  void _showSuccessDialog(BuildContext context, AppLocalizations l10n) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.checkCircle2,
                  size: 40,
                  color: AppColors.gold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.resetPasswordSuccessTitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          content: Text(
            l10n.resetPasswordSuccessMessage,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: l10n.backToLogin,
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  // Pop về route đầu tiên (MaterialApp.home chứa BlocBuilder)
                  // KHÔNG dùng pushAndRemoveUntil vì nó xóa luôn route gốc,
                  // làm BlocBuilder ở main.dart bị dispose và không rebuild khi state đổi
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                fullWidth: true,
              ),
            ),
          ],
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(
          l10n.resetPasswordTitle,
          style: GoogleFonts.beVietnamPro(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            AppSnackBar.error(context, state.message);
          } else if (state is AuthResetPasswordSuccess) {
            _showSuccessDialog(context, l10n);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SafeArea(
              child: AppLoadingOverlay(
                isLoading: isLoading,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom -
                          kToolbarHeight -
                          MediaQuery.of(context).padding.top -
                          32.0,
                    ),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 24),
                            Center(
                              child: Image.asset(
                                'assets/images/logo_launcher.png',
                                width: 80,
                                height: 80,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              l10n.resetPasswordTitle,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.crimson,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              l10n.resetPasswordSubtitle,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 36),
                            AppTextFieldLight(
                              label: l10n.newPasswordLabel,
                              controller: _passwordController,
                              obscureText: _isObscureNew,
                              enabled: !isLoading,
                              hintText: l10n.passwordHint,
                              prefixIcon: Icon(
                                LucideIcons.lock,
                                size: 20,
                                color: AppColors.textSecondary
                                    .withValues(alpha: 0.5),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscureNew
                                      ? LucideIcons.eyeOff
                                      : LucideIcons.eye,
                                  color: AppColors.textSecondary
                                      .withValues(alpha: 0.5),
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscureNew = !_isObscureNew;
                                  });
                                },
                              ),
                              validator: (val) =>
                                  AppValidators.validateStrongPassword(
                                      context, val),
                            ),
                            const SizedBox(height: 20),
                            AppTextFieldLight(
                              label: l10n.confirmPasswordLabel,
                              controller: _confirmPasswordController,
                              obscureText: _isObscureConfirm,
                              enabled: !isLoading,
                              hintText: l10n.passwordHint,
                              prefixIcon: Icon(
                                LucideIcons.lock,
                                size: 20,
                                color: AppColors.textSecondary
                                    .withValues(alpha: 0.5),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscureConfirm
                                      ? LucideIcons.eyeOff
                                      : LucideIcons.eye,
                                  color: AppColors.textSecondary
                                      .withValues(alpha: 0.5),
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscureConfirm = !_isObscureConfirm;
                                  });
                                },
                              ),
                              validator: (val) =>
                                  AppValidators.validateConfirmPassword(
                                context,
                                val,
                                _passwordController.text,
                              ),
                            ),
                            const SizedBox(height: 32),
                            AppButton(
                              label: l10n.resetPasswordButton,
                              onPressed: _onSubmitPressed,
                              isLoading: false,
                              fullWidth: true,
                              size: AppButtonSize.large,
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
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
