import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'otp_verification_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmitPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthForgotPasswordRequested(
              email: _emailController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        backgroundColor: context.appBarBg,
        elevation: 0,
        iconTheme: IconThemeData(color: context.textPrimary),
        title: Text(
          l10n.forgotPasswordTitle,
          style: GoogleFonts.beVietnamPro(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: context.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            AppSnackBar.error(context, state.message);
          } else if (state is AuthForgotPasswordSent) {
            Navigator.pushReplacement(
              context,
              FadeScalePageRoute(
                page: OtpVerificationPage(email: _emailController.text.trim()),
              ),
            );
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
                              l10n.forgotPasswordTitle,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: context.primary,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              l10n.forgotPasswordSubtitle,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: context.textSecondary,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 36),
                            AppTextFieldLight(
                              label: l10n.emailLabel,
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              enabled: !isLoading,
                              hintText: l10n.emailHint,
                              prefixIcon: Icon(
                                LucideIcons.mail,
                                size: 20,
                                color: context.textSecondary
                                    .withValues(alpha: 0.5),
                              ),
                              validator: (val) =>
                                  AppValidators.validateEmail(context, val),
                            ),
                            const SizedBox(height: 32),
                            AppButton(
                              label: l10n.forgotPasswordButton,
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
