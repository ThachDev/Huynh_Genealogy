import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/app_snackbar.dart';

class AdminEditProfilePage extends StatefulWidget {
  const AdminEditProfilePage({super.key});

  @override
  State<AdminEditProfilePage> createState() => _AdminEditProfilePageState();
}

class _AdminEditProfilePageState extends State<AdminEditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Huỳnh Gia Trưởng');
  final _emailController = TextEditingController(text: 'truongtoc@gmail.com');
  final _phoneController = TextEditingController(text: '0987654321');
  final _addressController =
      TextEditingController(text: 'Từ đường họ Huỳnh, Quảng Nam');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        title: const Text('CHỈNH SỬA NGƯỜI DÙNG'),
        backgroundColor: AppColors.wood,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 10),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.wood.withValues(alpha: 0.2),
                    backgroundImage: const NetworkImage(
                      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=150',
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.crimson,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.camera,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildTextField(
              controller: _nameController,
              label: 'Họ và tên',
              icon: LucideIcons.user,
              validator: (val) => val == null || val.trim().isEmpty
                  ? 'Vui lòng nhập họ tên'
                  : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              icon: LucideIcons.mail,
              keyboardType: TextInputType.emailAddress,
              validator: (val) => val == null || !val.contains('@')
                  ? 'Email không hợp lệ'
                  : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _phoneController,
              label: 'Số điện thoại',
              icon: LucideIcons.phone,
              keyboardType: TextInputType.phone,
              validator: (val) => val == null || val.trim().length < 10
                  ? 'Số điện thoại không hợp lệ'
                  : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _addressController,
              label: 'Địa chỉ sinh sống',
              icon: LucideIcons.mapPin,
              maxLines: 2,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  AppSnackBar.success(
                      context, 'Đã cập nhật thông tin cá nhân!');
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.wood,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Lưu thay đổi',
                style: GoogleFonts.beVietnamPro(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.wood),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: AppColors.surface,
      ),
      style: GoogleFonts.beVietnamPro(fontSize: 14),
    );
  }
}
