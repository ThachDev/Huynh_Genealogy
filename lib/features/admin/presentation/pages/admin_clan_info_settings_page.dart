import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_snackbar.dart';

class AdminClanInfoSettingsPage extends StatefulWidget {
  const AdminClanInfoSettingsPage({super.key});

  @override
  State<AdminClanInfoSettingsPage> createState() => _AdminClanInfoSettingsPageState();
}

class _AdminClanInfoSettingsPageState extends State<AdminClanInfoSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _originController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Default initial mock values representing the Clan Info
    _nameController = TextEditingController(text: 'Huỳnh Gia Tộc');
    _descController = TextEditingController(
      text: 'Dòng họ Huỳnh phát tích từ vùng đất Quảng Nam, trải qua nhiều đời gìn giữ gia phong và nề nếp gia đình.',
    );
    _originController = TextEditingController(text: 'Điện Bàn, Quảng Nam');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _originController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        setState(() => _isSaving = false);
        AppSnackBar.success(context, 'Cập nhật thông tin dòng tộc thành công!');
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        title: const Text('THÔNG TIN DÒNG TỘC'),
        backgroundColor: AppColors.wood,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner & Avatar Preview
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.crimson.withValues(alpha: 0.15),
                    image: const DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1507679799987-c73779587ccf?q=80&w=600'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.3),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: 0.9),
                    radius: 18,
                    child: IconButton(
                      icon: const Icon(LucideIcons.camera, size: 16, color: AppColors.crimson),
                      onPressed: () {
                        AppSnackBar.info(context, 'Tính năng tải lên ảnh bìa đang được chuẩn bị');
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: -50,
                  left: 20,
                  child: Stack(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: AppColors.parchment,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.gold, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: const Center(
                          child: Icon(LucideIcons.shield, size: 45, color: AppColors.crimson),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: AppColors.gold,
                          radius: 14,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(LucideIcons.edit2, size: 12, color: Colors.white),
                            onPressed: () {
                              AppSnackBar.info(context, 'Tính năng tải lên biểu tượng dòng tộc đang được phát triển');
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 70),

            // Form Fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thông tin cơ bản',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.crimson,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppTextFieldLight(
                      controller: _nameController,
                      label: 'Tên dòng tộc',
                      hintText: 'Nhập tên dòng tộc của bạn',
                      prefixIcon: const Icon(LucideIcons.award, color: AppColors.crimson),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Vui lòng nhập tên dòng tộc';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextFieldLight(
                      controller: _originController,
                      label: 'Quê quán / Nguồn gốc',
                      hintText: 'Nhập quê quán tổ tiên dòng tộc',
                      prefixIcon: const Icon(LucideIcons.mapPin, color: AppColors.crimson),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Vui lòng nhập địa chỉ nguồn gốc dòng tộc';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextFieldLight(
                      controller: _descController,
                      label: 'Mô tả chi tiết',
                      hintText: 'Tóm tắt lịch sử, gia phong dòng họ',
                      maxLines: 4,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 50),
                        child: Icon(LucideIcons.text, color: AppColors.crimson),
                      ),
                    ),
                    const SizedBox(height: 32),
                    AppButton(
                      label: 'LƯU THAY ĐỔI',
                      onPressed: _saveChanges,
                      isLoading: _isSaving,
                      fullWidth: true,
                      size: AppButtonSize.large,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
