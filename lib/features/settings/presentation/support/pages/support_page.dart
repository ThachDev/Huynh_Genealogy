import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/components/theme/app_theme.dart';
import 'package:app_family_tree/components/app_bar/app_bar.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/widgets/tree_background_painter.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  Future<void> _launchUrlHelper(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri uri = Uri(scheme: 'mailto', path: email);
    if (!await launchUrl(uri)) {
      debugPrint('Could not launch $email');
    }
  }

  Future<void> _makeCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber.replaceAll(' ', ''));
    if (!await launchUrl(uri)) {
      debugPrint('Could not launch $phoneNumber');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: const CommonAppBar(titleText: 'HỎI ĐÁP', centerTitle: true),
      body: Stack(
        children: [
          const Positioned.fill(
            child: CustomPaint(painter: TreeBackgroundPainter()),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildContactInfo(),
                const SizedBox(height: 40),
                Text(
                  'HỎI ĐÁP',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.crimson,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 20),
                _buildFAQItem(
                  'Làm sao để thêm người trong gia đình?',
                  'Bạn chọn nút "Thêm thành viên" (+), sau đó nhập thông tin và chọn đúng mối quan hệ trong gia đình.',
                ),
                _buildFAQItem(
                  'Vì sao tôi không chỉnh sửa được thông tin?',
                  'Để đảm bảo tính chính xác của gia phả, chỉ một số thành viên được giao trách nhiệm mới có quyền chỉnh sửa dữ liệu.',
                ),
                _buildFAQItem(
                  'Tôi có thể cập nhật thông tin bằng cách nào?',
                  'Bạn có thể liên hệ với người quản lý gia phả trong dòng họ để được hỗ trợ cập nhật hoặc chỉnh sửa thông tin.',
                ),
                _buildFAQItem(
                  'Thông tin gia phả được lưu ở đâu?',
                  'Dữ liệu được lưu trữ an toàn và chỉ sử dụng trong phạm vi nội bộ dòng họ.',
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          _buildContactRow(
            Icons.email_outlined,
            'Email hỗ trợ',
            'thachhuynh.dev@gmail.com',
            onTap: () => _sendEmail('thachhuynh.dev@gmail.com'),
          ),
          const Divider(height: 32),
          _buildContactRow(
            Icons.phone_outlined,
            'Hotline',
            '+84 364 749 854',
            onTap: () => _makeCall('+84 364 749 854'),
          ),
          const Divider(height: 32),
          _buildContactRow(
            Icons.facebook,
            'Nhóm Facebook',
            'Gia Tộc Họ Huỳnh Việt Nam',
            onTap: () => _launchUrlHelper(
              'https://www.facebook.com/groups/giaphahohuynh/',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(
    IconData icon,
    String title,
    String content, {
    VoidCallback? onTap,
  }) {
    return Row(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.crimson, size: 20),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                content,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      iconColor: AppColors.gold,
      collapsedIconColor: AppColors.crimson,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answer,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
