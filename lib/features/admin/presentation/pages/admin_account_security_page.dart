import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/utils/validators.dart';

class AdminAccountSecurityPage extends StatefulWidget {
  const AdminAccountSecurityPage({super.key});

  @override
  State<AdminAccountSecurityPage> createState() => _AdminAccountSecurityPageState();
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
      setState(() => _isSaving = true);
      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted) {
        setState(() => _isSaving = false);
        AppSnackBar.success(context, 'Thay đổi mật khẩu thành công!');
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        title: const Text('BẢO MẬT TÀI KHOẢN'),
        backgroundColor: AppColors.wood,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Đổi mật khẩu',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.crimson,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Mật khẩu mới của bạn cần chứa ít nhất 8 ký tự, bao gồm cả chữ số, chữ hoa và ký tự đặc biệt để đảm bảo an toàn.',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              AppTextFieldLight(
                controller: _currentPasswordController,
                label: 'Mật khẩu hiện tại',
                hintText: 'Nhập mật khẩu đang sử dụng',
                obscureText: true,
                prefixIcon: const Icon(LucideIcons.lock, color: AppColors.crimson),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Vui lòng nhập mật khẩu hiện tại';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextFieldLight(
                controller: _newPasswordController,
                label: 'Mật khẩu mới',
                hintText: 'Nhập mật khẩu mới mạnh mẽ',
                obscureText: true,
                prefixIcon: const Icon(LucideIcons.key, color: AppColors.crimson),
                validator: (val) => AppValidators.validateStrongPassword(context, val),
              ),
              const SizedBox(height: 16),
              AppTextFieldLight(
                controller: _confirmPasswordController,
                label: 'Xác nhận mật khẩu mới',
                hintText: 'Nhập lại mật khẩu mới',
                obscureText: true,
                prefixIcon: const Icon(LucideIcons.checkSquare, color: AppColors.crimson),
                validator: (val) => AppValidators.validateConfirmPassword(
                  context,
                  val,
                  _newPasswordController.text,
                ),
              ),
              const SizedBox(height: 32),
              AppButton(
                label: 'CẬP NHẬT MẬT KHẨU',
                onPressed: _updatePassword,
                isLoading: _isSaving,
                fullWidth: true,
                size: AppButtonSize.large,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
