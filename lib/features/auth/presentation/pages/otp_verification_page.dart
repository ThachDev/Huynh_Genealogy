import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'reset_password_page.dart';

class OtpVerificationPage extends StatefulWidget {

  const OtpVerificationPage({super.key, required this.email});
  final String email;

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  // Countdown cho nút Gửi lại OTP (60 giây chống spam)
  static const int _countdownSeconds = 60;
  int _secondsLeft = 0;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    // Bắt đầu countdown ngay khi màn hình mở (OTP vừa gửi)
    _startCountdown();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    setState(() => _secondsLeft = _countdownSeconds);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  void _onSubmitPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthVerifyOtpRequested(
              email: widget.email,
              otp: _otpController.text.trim(),
            ),
          );
    }
  }

  void _onResendPressed() {
    if (_secondsLeft > 0) return; // Chưa hết countdown
    context.read<AuthBloc>().add(
          AuthForgotPasswordRequested(email: widget.email),
        );
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final canResend = _secondsLeft == 0;

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppAppBar(title: l10n.otpTitle),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            AppSnackBar.error(context, state.message);
          } else if (state is AuthOtpVerified) {
            Navigator.pushReplacement(
              context,
              FadeScalePageRoute(
                page: ResetPasswordPage(
                  email: widget.email,
                  otp: _otpController.text.trim(),
                ),
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SafeArea(
              child: AppLoadingOverlay(
                isLoading: false,
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
                              l10n.otpTitle,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: context.primary,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: context.textSecondary,
                                  height: 1.5,
                                ),
                                children: [
                                  TextSpan(text: l10n.otpSubtitleStart),
                                  TextSpan(
                                    text: widget.email,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: context.textPrimary,
                                    ),
                                  ),
                                  TextSpan(text: l10n.otpSubtitleEnd),
                                ],
                              ),
                            ),
                            const SizedBox(height: 36),
                            AppTextFieldLight(
                              label: l10n.otpLabel,
                              controller: _otpController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(6)
                              ],
                              enabled: !isLoading,
                              hintText: l10n.otpHint,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 8,
                                color: context.textPrimary,
                              ),
                              prefixIcon: Icon(
                                LucideIcons.keyRound,
                                size: 20,
                                color: context.textSecondary
                                    .withValues(alpha: 0.5),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return l10n.otpRequiredError;
                                }
                                if (val.trim().length != 6) {
                                  return l10n.otpInvalidError;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            AppButton(
                              label: l10n.otpVerifyButton,
                              onPressed: _onSubmitPressed,
                              isLoading: isLoading,
                              fullWidth: true,
                              size: AppButtonSize.large,
                            ),
                            const SizedBox(height: 16),

                            // Nút Gửi lại OTP với Countdown chống spam
                            canResend
                                ? TextButton(
                                    onPressed: isLoading ? null : _onResendPressed,
                                    child: Text(
                                      l10n.otpResendButton,
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: context.accent,
                                      ),
                                    ),
                                  )
                                : Text(
                                    l10n.otpResendCountdownFormat(_secondsLeft),
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: context.textSecondary,
                                    ),
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
