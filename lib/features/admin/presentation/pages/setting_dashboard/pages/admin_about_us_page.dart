import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/theme/app_theme.dart';

class AdminAboutUsPage extends StatelessWidget {
  const AdminAboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        title: const Text('VỀ CHÚNG TÔI'),
        backgroundColor: AppColors.wood,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gold, width: 2),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo_launcher.png',
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Gia Tộc Việt',
              style: GoogleFonts.beVietnamPro(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.wood,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Gia Tộc Việt giúp bạn gìn giữ cây gia phả dòng họ trên nền tảng số, '
              'kết nối các thế hệ dù ở bất kỳ nơi đâu. Từ ông bà tổ tiên đến con cháu hôm nay — tất cả đều trong tầm tay.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                height: 1.6,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 32),
            _buildInfoRow('Phiên bản', '1.0.0'),
            _buildDivider(),
            _buildInfoRow('Nhà phát triển', 'ThachDev'),
            _buildDivider(),
            _buildInfoRow('Email', 'thachhuynh.dev@gmail.com'),
            _buildDivider(),
            const SizedBox(height: 32),
            Text(
              '© 2026 ThachDev. Bảo lưu mọi quyền.',
              style: GoogleFonts.inter(
                fontSize: 10,
                color: AppColors.textSecondary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.beVietnamPro(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.gold.withValues(alpha: 0.08),
    );
  }
}
