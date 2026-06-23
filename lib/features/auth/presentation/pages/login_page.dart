import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tính năng Đăng nhập Email đang được phát triển. Vui lòng sử dụng Đăng nhập với Google.',
            style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          backgroundColor: AppColors.crimson,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _onGoogleLoginPressed() {
    context.read<AuthBloc>().add(AuthLoginRequested());
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    
    return Scaffold(
      backgroundColor: AppColors.wood, // Charcoal Black nền hệ thống
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: GoogleFonts.inter(color: Colors.white),
                ),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height - 
                                   MediaQuery.of(context).padding.top - 
                                   MediaQuery.of(context).padding.bottom - 32.0,
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
                              
                              const SizedBox(height: 48.0),
                              
                              // ─── WELCOME TEXTS ───
                              Text(
                                'Chào mừng trở lại',
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              Text(
                                'ĐĂNG NHẬP VÀO HỆ THỐNG GIA TỘC CỦA BẠN',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.nodeFemale.withValues(alpha: 0.6), // Dùng hồng nhạt hệ thống
                                  letterSpacing: 0.8,
                                ),
                              ),
                              
                              const SizedBox(height: 36.0),
                              
                              // ─── EMAIL INPUT ───
                              Text(
                                'ĐỊA CHỈ EMAIL',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.nodeFemale.withValues(alpha: 0.8), // Dùng hồng nhạt hệ thống
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                enabled: !isLoading,
                                style: GoogleFonts.inter(color: Colors.white),
                                decoration: _inputDecoration(hintText: 'email@example.com'),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Vui lòng nhập địa chỉ email';
                                  }
                                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                  if (!emailRegex.hasMatch(value)) {
                                    return 'Email không hợp lệ';
                                  }
                                  return null;
                                },
                              ),
                              
                              const SizedBox(height: 20.0),
                              
                              // ─── PASSWORD INPUT ───
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'MẬT KHẨU',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.nodeFemale.withValues(alpha: 0.8),
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: isLoading ? null : () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Vui lòng liên hệ Chủ quản dòng họ để được cấp lại mật khẩu.',
                                            style: GoogleFonts.inter(color: Colors.white),
                                          ),
                                          backgroundColor: AppColors.crimson,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'QUÊN MẬT KHẨU?',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.gold,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _isObscure,
                                enabled: !isLoading,
                                style: GoogleFonts.inter(color: Colors.white),
                                decoration: _inputDecoration(
                                  hintText: '••••••••',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                      color: AppColors.nodeFemale.withValues(alpha: 0.5),
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isObscure = !_isObscure;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng nhập mật khẩu';
                                  }
                                  if (value.length < 6) {
                                    return 'Mật khẩu phải từ 6 ký tự';
                                  }
                                  return null;
                                },
                              ),
                              
                              const SizedBox(height: 28.0),
                              
                              // ─── LOGIN BUTTON ───
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _onEmailLoginPressed,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.crimson,
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: AppColors.crimson.withValues(alpha: 0.6),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: Text(
                                    'ĐĂNG NHẬP',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 24.0),
                              
                              // ─── OR DIVIDER ───
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: Colors.white.withValues(alpha: 0.1),
                                      thickness: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text(
                                      'HOẶC',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.nodeFemale.withValues(alpha: 0.4),
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: Colors.white.withValues(alpha: 0.1),
                                      thickness: 1,
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 24.0),
                              
                              // ─── GOOGLE LOGIN BUTTON ───
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: OutlinedButton(
                                  onPressed: isLoading ? null : _onGoogleLoginPressed,
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    side: const BorderSide(color: AppColors.gold, width: 1.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'G',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 20,
                                          color: AppColors.gold,
                                        ),
                                      ),
                                      const SizedBox(width: 12.0),
                                      Text(
                                        'ĐĂNG NHẬP VỚI GOOGLE',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: AppColors.gold,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              const Spacer(),
                              
                              // ─── FOOTER ───
                              if (bottomInset == 0) ...[
                                const SizedBox(height: 24.0),
                                Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: isLoading ? null : () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Vui lòng liên hệ với ban trị sự dòng họ để được cấp tài khoản thành viên.',
                                            style: GoogleFonts.inter(color: Colors.white),
                                          ),
                                          backgroundColor: AppColors.crimson,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: Colors.white70,
                                        ),
                                        children: [
                                          const TextSpan(text: 'Chưa có tài khoản? '),
                                          TextSpan(
                                            text: 'ĐĂNG KÝ NGAY',
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.nodeFemale, // Dùng hồng nhạt hệ thống
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
                  if (isLoading)
                    Container(
                      color: Colors.black.withValues(alpha: 0.5),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogoAndTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Stylized block tree logo matching user image
        SizedBox(
          width: 32,
          height: 32,
          child: Stack(
            children: [
              // Left block
              Positioned(
                left: 0,
                top: 10,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.nodeFemale, // Hồng nhạt hệ thống
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ),
              // Right top block
              Positioned(
                left: 13,
                top: 2,
                child: Container(
                  width: 14,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.nodeFemale,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ),
              // Right bottom block
              Positioned(
                left: 13,
                top: 17,
                child: Container(
                  width: 14,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.nodeFemale,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12.0),
        Text(
          'GIA PHẢ VIỆT',
          style: GoogleFonts.beVietnamPro(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: AppColors.nodeFemale, // Hồng nhạt hệ thống
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({required String hintText, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.inter(
        color: Colors.white30,
        fontSize: 14,
      ),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.05), // Nền ô nhập liệu tối mờ từ màu nền
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.0),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15), width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.0),
        borderSide: const BorderSide(color: AppColors.gold, width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.0),
        borderSide: const BorderSide(color: AppColors.error, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.0),
        borderSide: const BorderSide(color: AppColors.error, width: 1.2),
      ),
      errorStyle: GoogleFonts.inter(
        color: AppColors.error,
        fontSize: 12,
      ),
    );
  }
}
