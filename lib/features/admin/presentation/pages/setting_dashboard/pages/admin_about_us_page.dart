import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Logo / Branding container
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.crimson.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gold, width: 2),
              ),
              child: const Center(
                child: Icon(LucideIcons.shield,
                    size: 55, color: AppColors.crimson),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Gia Tộc Việt',
              style: GoogleFonts.beVietnamPro(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.wood,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              'Phiên bản 1.0.0 (Beta)',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),

            // Mission Section
            _buildInfoBlock(
              icon: LucideIcons.heart,
              title: 'Sứ mệnh của chúng tôi',
              content:
                  'Gia Tộc Việt sinh ra để giúp các thế hệ người Việt gìn giữ cội nguồn dòng tộc. Chúng tôi số hóa cây gia phả truyền thống, mang lại phương thức lưu trữ trường tồn, giúp con cháu dễ dàng kết nối, tìm về tổ tiên và ghi nhận truyền thống vẻ vang của thế hệ đi trước.',
            ),
            const SizedBox(height: 24),

            // Value Cards
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Giá trị cốt lõi',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.wood,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildValueCard(
              title: 'Bảo tồn văn hóa phả hệ',
              desc:
                  'Ghi chép chính xác dòng lịch sử, vai vế thế hệ của từng thành viên gia tộc Việt.',
            ),
            _buildValueCard(
              title: 'Bảo mật thông tin tối đa',
              desc:
                  'Coi trọng quyền riêng tư của dòng họ, chỉ cho phép thành viên dòng tộc chia sẻ thông tin.',
            ),
            _buildValueCard(
              title: 'Dễ dàng kết nối',
              desc:
                  'Giao diện trực quan giúp người trẻ tiếp cận cội nguồn một cách hiện đại, sinh động nhất.',
            ),
            const SizedBox(height: 32),

            Text(
              '© 2026 ThachDev. Bảo lưu mọi quyền.',
              style: GoogleFonts.inter(
                fontSize: 10,
                color: AppColors.textSecondary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBlock({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: AppColors.crimson),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.beVietnamPro(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.crimson,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          content,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textPrimary,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildValueCard({required String title, required String desc}) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.gold.withValues(alpha: 0.1)),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(LucideIcons.checkCircle2,
                color: AppColors.crimson, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.wood,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
