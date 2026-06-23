import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/utils/validators.dart';
import '../../../../main.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      AppSnackBar.warning(
        context,
        'Tính năng Đăng nhập Email đang được phát triển. Vui lòng sử dụng Đăng nhập với Google.',
      );
    }
  }

  void _onGoogleLoginPressed() {
    context.read<AuthBloc>().add(AuthLoginRequested());
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
                                const SizedBox(height: 16.0),
                                // ─── LOGO & APP TITLE ───
                                _buildLogoAndTitle(),

                                // ─── WELCOME TEXTS ───
                                Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        l10n.loginTitle,
                                        style: GoogleFonts.beVietnamPro(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.crimson,
                                          height: 1.2,
                                        ),
                                      ),
                                      const SizedBox(height: 6.0),
                                      Text(
                                        l10n.loginSubtitle,
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textSecondary,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 36.0),

                                // ─── EMAIL INPUT ───
                                AppTextFieldLight(
                                  label: l10n.emailLabel,
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  enabled: !isLoading,
                                  hintText: l10n.emailHint,
                                  validator: AppValidators.validateEmail,
                                ),

                                const SizedBox(height: 20.0),

                                // ─── PASSWORD INPUT ───
                                AppTextFieldLight(
                                  label: l10n.passwordLabel,
                                  controller: _passwordController,
                                  obscureText: _isObscure,
                                  enabled: !isLoading,
                                  hintText: l10n.passwordHint,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isObscure
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: AppColors.textSecondary
                                          .withOpacity(0.5),
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isObscure = !_isObscure;
                                      });
                                    },
                                  ),
                                  validator: AppValidators.validatePassword,
                                ),
                                const SizedBox(height: 8.0),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: isLoading
                                        ? null
                                        : () {
                                            AppSnackBar.info(
                                              context,
                                              'Vui lòng liên hệ Chủ quản dòng họ để được cấp lại mật khẩu.',
                                            );
                                          },
                                    child: Text(
                                      l10n.forgotPassword,
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.gold,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 28.0),

                                // ─── LOGIN BUTTON ───
                                AppButton(
                                  label: l10n.loginButton,
                                  onPressed: _onEmailLoginPressed,
                                  isLoading: isLoading,
                                  fullWidth: true,
                                  size: AppButtonSize.large,
                                ),

                                const SizedBox(height: 24.0),

                                // ─── OR DIVIDER ───
                                AppLabeledDivider(
                                  label: l10n.orDivider,
                                  isLight: true,
                                ),

                                const SizedBox(height: 24.0),

                                // ─── GOOGLE LOGIN BUTTON ───
                                AppButton(
                                  label: l10n.googleLoginButton,
                                  onPressed: _onGoogleLoginPressed,
                                  variant: AppButtonVariant.outline,
                                  size: AppButtonSize.large,
                                  fullWidth: true,
                                  prefixIcon: Image.asset(
                                    'assets/images/google.png',
                                    width: 20,
                                    height: 20,
                                  ),
                                ),

                                const Spacer(),

                                // ─── FOOTER ───
                                if (bottomInset == 0) ...[
                                  const SizedBox(height: 24.0),
                                  Align(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: isLoading
                                          ? null
                                          : () {
                                              AppSnackBar.info(
                                                context,
                                                'Vui lòng liên hệ với ban trị sự dòng họ để được cấp tài khoản thành viên.',
                                              );
                                            },
                                      child: RichText(
                                        text: TextSpan(
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            color: AppColors.textSecondary,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: l10n.noAccountText,
                                            ),
                                            TextSpan(
                                              text: l10n.registerNow,
                                              style: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.crimson,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8.0,
                      right: 16.0,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.language_rounded,
                            size: 18,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            isEnglish ? 'EN' : 'VI',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Switch(
                            value: isEnglish,
                            onChanged: (value) {
                              final newLocale = value
                                  ? const Locale('en')
                                  : const Locale('vi');
                              FamilyTreeApp.setLocale(context, newLocale);
                            },
                            activeColor: AppColors.gold,
                            activeTrackColor: AppColors.gold.withOpacity(0.3),
                            inactiveThumbColor: AppColors.crimson,
                            inactiveTrackColor:
                                AppColors.crimson.withOpacity(0.2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogoAndTitle() {
    return Center(
      child: Image.asset(
        'assets/images/logo_launcher.png',
        width: 80,
        height: 80,
        fit: BoxFit.contain,
      ),
    );
  }
}
