import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/components/theme/app_theme.dart';
import 'package:app_family_tree/components/app_bar/app_bar.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/widgets/tree_background_painter.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: const CommonAppBar(titleText: 'VỀ ỨNG DỤNG', centerTitle: true),
      body: Stack(
        children: [
          const Positioned.fill(
            child: CustomPaint(painter: TreeBackgroundPainter()),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 15),
                Text(
                  'Gia Phả Họ Huỳnh',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.crimson,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '"Cây có gốc mới nở ngành xanh ngọn,\nNước có nguồn mới bể rộng sông sâu"',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                // Content Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        Icons.history_edu,
                        'Về ứng dụng',
                        'Ứng dụng được tạo ra nhằm lưu giữ, kết nối và phát huy truyền thống của dòng họ, giúp con cháu hiểu rõ cội nguồn và gìn giữ giá trị gia đình qua nhiều thế hệ.',
                      ),
                      const Divider(height: 32),
                      _buildInfoRow(
                        Icons.developer_mode,
                        'Tâm huyết thực hiện',
                        'Được xây dựng bởi con cháu trong dòng họ với mong muốn lưu giữ những ký ức, câu chuyện và giá trị tốt đẹp của gia đình.',
                      ),
                      const Divider(height: 32),
                      _buildInfoRow(
                        Icons.copyright,
                        'Ghi chú',
                        '© 2026 Gia phả họ Huỳnh. Lưu hành nội bộ.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Phiên bản 1.0.0',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.crimson, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.6,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
