import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/utils/validators.dart';
import '../../../../main.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;
  bool _isTermsAccepted = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    final l10n = AppLocalizations.of(context)!;
    if (!_isTermsAccepted) {
      AppSnackBar.warning(context, l10n.termsValidationErr);
      return;
    }
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthRegisterRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              fullName: _fullNameController.text.trim(),
              role: 'VIEWER',
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final l10n = AppLocalizations.of(context)!;
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            AppSnackBar.error(context, state.message);
          } else if (state is Authenticated) {
            // Once authenticated, the root MaterialApp swaps to Dashboard,
            // but we pop just in case to clean up navigation history.
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SafeArea(
              child: AppLoadingOverlay(
                isLoading: isLoading,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height -
                              MediaQuery.of(context).padding.top -
                              MediaQuery.of(context).padding.bottom -
                              32.0,
                        ),
                        child: IntrinsicHeight(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Spacer(),
                                _buildLogo(),
                                _buildWelcomeTexts(l10n),
                                const SizedBox(height: 32.0),
                                _buildFullNameInput(isLoading, l10n),
                                const SizedBox(height: 16.0),
                                _buildEmailInput(isLoading, l10n),
                                const SizedBox(height: 16.0),
                                _buildPasswordInput(isLoading, l10n),
                                const SizedBox(height: 16.0),
                                _buildConfirmPasswordInput(isLoading, l10n),
                                const SizedBox(height: 16.0),
                                _buildTermsCheckbox(isLoading, l10n),
                                const SizedBox(height: 24.0),
                                _buildRegisterButton(isLoading, l10n),
                                const Spacer(),
                                if (bottomInset == 0) ...[
                                  const SizedBox(height: 24.0),
                                  _buildLoginFooter(isLoading, l10n),
                                  const SizedBox(height: 16.0),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Navigation Bar (Back Button + Language Switcher)
                    _buildTopBar(context, isEnglish),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, bool isEnglish) {
    return Positioned(
      top: 12.0,
      right: 16.0,
      child: _buildLanguageSwitcher(context, isEnglish),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Image.asset(
        'assets/images/logo_launcher.png',
        width: 72,
        height: 72,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildWelcomeTexts(AppLocalizations l10n) {
    return Center(
      child: Column(
        children: [
          Text(
            l10n.registerTitle,
            style: GoogleFonts.beVietnamPro(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.crimson,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            l10n.registerSubtitle,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullNameInput(bool isLoading, AppLocalizations l10n) {
    return AppTextFieldLight(
      label: l10n.fullNameLabel,
      controller: _fullNameController,
      keyboardType: TextInputType.name,
      enabled: !isLoading,
      hintText: l10n.fullNameHint,
      validator: (val) => AppValidators.validateFullName(context, val),
    );
  }

  Widget _buildEmailInput(bool isLoading, AppLocalizations l10n) {
    return AppTextFieldLight(
      label: l10n.emailLabel,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      enabled: !isLoading,
      hintText: l10n.emailHint,
      validator: (val) => AppValidators.validateEmail(context, val),
    );
  }

  Widget _buildPasswordInput(bool isLoading, AppLocalizations l10n) {
    return AppTextFieldLight(
      label: l10n.passwordLabel,
      controller: _passwordController,
      obscureText: _isPasswordObscure,
      enabled: !isLoading,
      hintText: l10n.passwordHint,
      suffixIcon: IconButton(
        icon: Icon(
          _isPasswordObscure ? LucideIcons.eyeOff : LucideIcons.eye,
          color: AppColors.textSecondary.withValues(alpha: 0.5),
          size: 20,
        ),
        onPressed: () {
          setState(() {
            _isPasswordObscure = !_isPasswordObscure;
          });
        },
      ),
      validator: (val) => AppValidators.validateStrongPassword(context, val),
    );
  }

  Widget _buildConfirmPasswordInput(bool isLoading, AppLocalizations l10n) {
    return AppTextFieldLight(
      label: l10n.confirmPasswordLabel,
      controller: _confirmPasswordController,
      obscureText: _isConfirmPasswordObscure,
      enabled: !isLoading,
      hintText: l10n.confirmPasswordHint,
      suffixIcon: IconButton(
        icon: Icon(
          _isConfirmPasswordObscure ? LucideIcons.eyeOff : LucideIcons.eye,
          color: AppColors.textSecondary.withValues(alpha: 0.5),
          size: 20,
        ),
        onPressed: () {
          setState(() {
            _isConfirmPasswordObscure = !_isConfirmPasswordObscure;
          });
        },
      ),
      validator: (value) => AppValidators.validateConfirmPassword(
        context,
        value,
        _passwordController.text,
      ),
    );
  }

  Widget _buildRegisterButton(bool isLoading, AppLocalizations l10n) {
    return AppButton(
      label: l10n.registerButton,
      onPressed: _onRegisterPressed,
      isLoading: false,
      fullWidth: true,
      size: AppButtonSize.large,
    );
  }

  Widget _buildLoginFooter(bool isLoading, AppLocalizations l10n) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: isLoading ? null : () => Navigator.pop(context),
        child: RichText(
          text: TextSpan(
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
            children: [
              TextSpan(
                text: l10n.alreadyHaveAccountText,
              ),
              TextSpan(
                text: l10n.loginNow,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: AppColors.crimson,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSwitcher(BuildContext context, bool isEnglish) {
    return GestureDetector(
      onTap: () {
        final newLocale = isEnglish ? const Locale('vi') : const Locale('en');
        FamilyTreeApp.setLocale(context, newLocale);
      },
      child: Container(
        width: 76,
        height: 26,
        decoration: BoxDecoration(
          color: AppColors.textSecondary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(13.0),
          border: Border.all(
            color: AppColors.textSecondary.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment:
                  isEnglish ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  width: 34,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'VI',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight:
                            !isEnglish ? FontWeight.bold : FontWeight.w600,
                        color: !isEnglish
                            ? AppColors.crimson
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'EN',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight:
                            isEnglish ? FontWeight.bold : FontWeight.w600,
                        color: isEnglish
                            ? AppColors.gold
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox(bool isLoading, AppLocalizations l10n) {
    return GestureDetector(
      onTap: isLoading
          ? null
          : () {
              setState(() {
                _isTermsAccepted = !_isTermsAccepted;
              });
            },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: _isTermsAccepted,
              onChanged: isLoading
                  ? null
                  : (value) {
                      setState(() {
                        _isTermsAccepted = value ?? false;
                      });
                    },
              activeColor: AppColors.crimson,
              checkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              side: BorderSide(
                color: AppColors.textSecondary.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                children: [
                  TextSpan(text: l10n.acceptTermsText),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: GestureDetector(
                      onTap: () =>
                          _showTermsDialog(context, l10n.termsOfService),
                      child: Text(
                        l10n.termsOfService,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          color: AppColors.crimson,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  TextSpan(text: l10n.andText),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: GestureDetector(
                      onTap: () =>
                          _showPrivacyPolicyDialog(context, l10n.privacyPolicy),
                      child: Text(
                        l10n.privacyPolicy,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          color: AppColors.crimson,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog(BuildContext context, String title) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: GoogleFonts.beVietnamPro(
            fontWeight: FontWeight.bold,
            color: AppColors.crimson,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(
              l10n.termsContent,
              textAlign: TextAlign.justify,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.closeButton,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: AppColors.crimson,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context, String title) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: GoogleFonts.beVietnamPro(
            fontWeight: FontWeight.bold,
            color: AppColors.crimson,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(
              l10n.privacyContent,
              textAlign: TextAlign.justify,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.closeButton,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: AppColors.crimson,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
