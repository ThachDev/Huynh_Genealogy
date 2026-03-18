import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/app/app_theme.dart';
import 'package:app_family_tree/features/language/presentation/widgets/language_selector.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/widgets/tree_background_painter.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        title: Text(
          'CÀI ĐẶT',
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            color: AppColors.gold,
            letterSpacing: 1.5,
          ),
        ),
        backgroundColor: AppColors.wood,
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          const Positioned.fill(
            child: CustomPaint(painter: TreeBackgroundPainter()),
          ),
          ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildSectionTitle('Cài đặt / Settings'),
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppColors.gold.withValues(alpha: 0.2)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.language, color: AppColors.crimson),
                    ),
                    title: Text(
                      'Ngôn ngữ',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      'Thay đổi ngôn ngữ hiển thị',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    trailing: const LanguageSelector(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Thông tin / Information'),
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppColors.gold.withValues(alpha: 0.2)),
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.info_outline,
                      title: 'Về ứng dụng',
                      onTap: () {},
                    ),
                    Divider(color: AppColors.gold.withValues(alpha: 0.2), height: 1),
                    _buildMenuItem(
                      icon: Icons.help_outline,
                      title: 'Trợ giúp & Hỗ trợ',
                      onTap: () {},
                    ),
                    Divider(color: AppColors.gold.withValues(alpha: 0.2), height: 1),
                    _buildMenuItem(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Chính sách bảo mật',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
      child: Row(
        children: [
          Container(width: 4, height: 16, color: AppColors.crimson),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.gold.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.crimson),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.gold),
      onTap: onTap,
    );
  }
}
