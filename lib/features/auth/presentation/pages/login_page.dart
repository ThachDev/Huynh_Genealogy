import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/utils/validators.dart';
import '../../../../main.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../domain/usecase/get_cached_credentials.dart';
import '../../../../core/usecases/usecase.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isObscure = true;
  bool _rememberPassword = false;

  @override
  void initState() {
    super.initState();
    // Tải credentials đã ghi nhớ (nếu có) trực tiếp để không ghi đè AuthState
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final getCachedCredentials = di.sl<GetCachedCredentials>();
    final result = await getCachedCredentials(NoParams());
    result.fold(
      (_) {},
      (credentials) {
        if (credentials != null && mounted) {
          setState(() {
            _emailController.text = credentials['email'] ?? '';
            _passwordController.text = credentials['password'] ?? '';
            _rememberPassword = true;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthLoginWithEmailRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
    }
  }


  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final l10n = AppLocalizations.of(context);
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';

    return Scaffold(
      backgroundColor: context.background,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            AppSnackBar.error(context, state.message);
          } else if (state is Authenticated) {
            // Lưu hoặc xoá credentials tuỳ theo lựa chọn của user
            if (_rememberPassword) {
              context.read<AuthBloc>().add(
                    AuthCacheCredentialsRequested(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    ),
                  );
            } else {
              context.read<AuthBloc>().add(AuthClearCredentialsRequested());
            }
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SafeArea(
              child: AppLoadingOverlay(
                isLoading: false,
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
                                const SizedBox(height: 36.0),
                                _buildEmailInput(isLoading, l10n),
                                const SizedBox(height: 20.0),
                                _buildPasswordInput(isLoading, l10n),
                                const SizedBox(height: 8.0),
                                _buildRememberAndForgotPassword(
                                    isLoading, l10n),
                                const SizedBox(height: 28.0),
                                _buildLoginButton(isLoading, l10n),

                                const Spacer(),
                                if (bottomInset == 0) ...[
                                  const SizedBox(height: 24.0),
                                  _buildRegisterFooter(isLoading, l10n),
                                  const SizedBox(height: 16.0),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    _buildTopControls(context, isEnglish),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Image.asset(
        'assets/images/logo_launcher.png',
        width: 80,
        height: 80,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildWelcomeTexts(AppLocalizations l10n) {
    return Center(
      child: Column(
        children: [
          Text(
            l10n.loginButton,
            style: GoogleFonts.beVietnamPro(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: context.primary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            l10n.loginSubtitle,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: context.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
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
      obscureText: _isObscure,
      enabled: !isLoading,
      hintText: l10n.passwordHint,
      suffixIcon: IconButton(
        icon: Icon(
          _isObscure ? LucideIcons.eyeOff : LucideIcons.eye,
          color: context.textSecondary.withValues(alpha: 0.5),
          size: 20,
        ),
        onPressed: () {
          setState(() {
            _isObscure = !_isObscure;
          });
        },
      ),
      validator: (val) => AppValidators.validatePassword(context, val),
    );
  }

  Widget _buildRememberAndForgotPassword(
      bool isLoading, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: isLoading
              ? null
              : () {
                  setState(() {
                    _rememberPassword = !_rememberPassword;
                  });
                },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: _rememberPassword,
                  onChanged: isLoading
                      ? null
                      : (value) {
                          setState(() {
                            _rememberPassword = value ?? false;
                          });
                        },
                  activeColor: context.primary,
                  checkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  side: BorderSide(
                    color: context.textSecondary.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Text(
                l10n.rememberMe,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: context.textSecondary,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: isLoading
              ? null
              : () {
                  Navigator.push(
                    context,
                    FadeScalePageRoute(page: const ForgotPasswordPage()),
                  );
                },
          child: Text(
            l10n.forgotPassword,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: context.accent,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(bool isLoading, AppLocalizations l10n) {
    return AppButton(
      label: l10n.loginButton,
      onPressed: _onEmailLoginPressed,
      isLoading: isLoading,
      fullWidth: true,
      size: AppButtonSize.large,
    );
  }


  Widget _buildRegisterFooter(bool isLoading, AppLocalizations l10n) {
    return Align(
      child: GestureDetector(
        onTap: isLoading
            ? null
            : () {
                Navigator.push(
                  context,
                  FadeScalePageRoute(page: const RegisterPage()),
                );
              },
        child: RichText(
          text: TextSpan(
            style: GoogleFonts.inter(
              fontSize: 13,
              color: context.textSecondary,
            ),
            children: [
              TextSpan(
                text: l10n.noAccountText,
              ),
              TextSpan(
                text: l10n.registerNow,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: context.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopControls(BuildContext context, bool isEnglish) {
    final isDark = context.isDarkMode;
    return Positioned(
      top: 12.0,
      right: 16.0,
      child: Container(
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: context.textSecondary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: context.textSecondary.withValues(alpha: 0.14),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Theme Toggle
            GestureDetector(
              onTap: () {
                final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
                FamilyTreeApp.setThemeMode(context, newMode);
              },
              child: Container(
                width: 52,
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Stack(
                  children: [
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      alignment:
                          isDark ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: context.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: context.resolve(
                                  Colors.black.withValues(alpha: 0.12),
                                  Colors.transparent),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Icon(
                              LucideIcons.sun,
                              size: 12,
                              color: !isDark
                                  ? context.primary
                                  : context.textSecondary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Icon(
                              LucideIcons.moon,
                              size: 12,
                              color: isDark
                                  ? const Color(0xFFFF5252)
                                  : context.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 2. Vertical Divider
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              width: 1,
              height: 14,
              color: context.textSecondary.withValues(alpha: 0.2),
            ),

            // 3. Language Toggle
            GestureDetector(
              onTap: () {
                final newLocale =
                    isEnglish ? const Locale('vi') : const Locale('en');
                FamilyTreeApp.setLocale(context, newLocale);
              },
              child: Container(
                width: 56,
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Stack(
                  children: [
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      alignment: isEnglish
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: 26,
                        height: 24,
                        decoration: BoxDecoration(
                          color: context.surface,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: context.resolve(
                                  Colors.black.withValues(alpha: 0.12),
                                  Colors.transparent),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
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
                                fontWeight: !isEnglish
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                color: !isEnglish
                                    ? context.primary
                                    : context.textSecondary,
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
                                fontWeight: isEnglish
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                color: isEnglish
                                    ? context.accent
                                    : context.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
