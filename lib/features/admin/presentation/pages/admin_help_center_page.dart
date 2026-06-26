import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_snackbar.dart';

class AdminHelpCenterPage extends StatelessWidget {
  const AdminHelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        title: const Text('TRUNG TÂM HỖ TRỢ'),
        backgroundColor: AppColors.wood,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.crimson, AppColors.wood],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.crimson.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chúng tôi có thể giúp gì cho bạn?',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Liên hệ hỗ trợ kỹ thuật hoặc xem hướng dẫn giải quyết các thắc mắc nhanh bên dưới.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Contact Cards
          Text(
            'Liên hệ trực tiếp',
            style: GoogleFonts.beVietnamPro(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.wood,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildContactCard(
                  context: context,
                  icon: LucideIcons.phoneCall,
                  title: 'Hotline hỗ trợ',
                  value: '1900 8888',
                  onTap: () {
                    AppSnackBar.info(context, 'Đang chuẩn bị kết nối cuộc gọi tới 1900 8888');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildContactCard(
                  context: context,
                  icon: LucideIcons.mail,
                  title: 'Email kỹ thuật',
                  value: 'support@giatocviet.vn',
                  onTap: () {
                    AppSnackBar.info(context, 'Đang mở ứng dụng email gửi tới support@giatocviet.vn');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // FAQ Section
          Text(
            'Câu hỏi thường gặp (FAQs)',
            style: GoogleFonts.beVietnamPro(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.wood,
            ),
          ),
          const SizedBox(height: 12),
          _buildFaqItem(
            question: 'Làm thế nào để thêm thành viên mới vào cây?',
            answer: 'Bạn cần đăng nhập bằng tài khoản Trưởng tộc hoặc Biên soạn, truy cập cây gia phả và nhấp vào biểu tượng dấu cộng (+) trên nút của thành viên để liên kết con hoặc phối ngẫu.',
          ),
          _buildFaqItem(
            question: 'Mã mời gia tộc hoạt động như thế nào?',
            answer: 'Mỗi gia phả có một mã mời duy nhất (ví dụ: HGT-2024). Trưởng tộc gửi mã này cho thành viên để họ nhập lúc đăng ký, kết nối trực tiếp vào cây phả hệ dòng họ.',
          ),
          _buildFaqItem(
            question: 'Tôi có thể phân quyền biên soạn cho người khác không?',
            answer: 'Có. Tại màn hình Danh sách thành viên trên Dashboard, Trưởng tộc có thể chọn thành viên và nâng cấp vai trò thành Biên soạn hoặc Quản trị chi.',
          ),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }

  Widget _buildContactCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.crimson, size: 24),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem({required String question, required String answer}) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.gold.withValues(alpha: 0.1)),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          question,
          style: GoogleFonts.beVietnamPro(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.wood,
          ),
        ),
        iconColor: AppColors.crimson,
        collapsedIconColor: AppColors.textSecondary,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Text(
              answer,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
