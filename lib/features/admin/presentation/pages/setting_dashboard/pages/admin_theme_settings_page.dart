import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/app_snackbar.dart';

class AdminThemeSettingsPage extends StatefulWidget {
  const AdminThemeSettingsPage({super.key});

  @override
  State<AdminThemeSettingsPage> createState() => _AdminThemeSettingsPageState();
}

class _AdminThemeSettingsPageState extends State<AdminThemeSettingsPage> {
  @override
  Widget build(BuildContext context) {
    // Determine the current system theme state
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        title: const Text('GIAO DIỆN HỆ THỐNG'),
        backgroundColor: AppColors.wood,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chọn chế độ hiển thị phù hợp với trải nghiệm đọc phả hệ:',
              style: GoogleFonts.beVietnamPro(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: AppColors.gold.withValues(alpha: 0.15)),
              ),
              child: Column(
                children: [
                  _buildThemeOption(
                    title: 'Giao diện sáng',
                    subtitle: 'Tối ưu cho việc đọc văn bản trên nền giấy cổ',
                    icon: LucideIcons.sun,
                    isSelected: !isDark,
                    onTap: () {
                      AppSnackBar.success(
                          context, 'Đã kích hoạt Giao diện Sáng');
                    },
                  ),
                  Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.gold.withValues(alpha: 0.05)),
                  _buildThemeOption(
                    title: 'Giao diện tối',
                    subtitle: 'Giảm mỏi mắt khi tra cứu phả hệ ban đêm',
                    icon: LucideIcons.moon,
                    isSelected: isDark,
                    onTap: () {
                      AppSnackBar.success(
                          context, 'Đã kích hoạt Giao diện Tối');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (isSelected ? AppColors.crimson : AppColors.wood)
                    .withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected ? AppColors.crimson : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? AppColors.crimson
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                LucideIcons.check,
                color: AppColors.crimson,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
