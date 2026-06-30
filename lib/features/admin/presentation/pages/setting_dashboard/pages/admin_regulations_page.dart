import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/theme/app_theme.dart';

class AdminRegulationsPage extends StatelessWidget {
  const AdminRegulationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        title: const Text('QUY ĐỊNH & ĐIỀU KHOẢN'),
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
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.crimson.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.fileText,
                    color: AppColors.crimson, size: 40),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Điều khoản sử dụng Gia Tộc Việt',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.wood,
                ),
              ),
            ),
            Center(
              child: Text(
                'Cập nhật lần cuối: Tháng 6, 2026',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildRegulationSection(
              title: '1. Quy định chung',
              content:
                  'Ứng dụng Gia Tộc Việt được xây dựng nhằm mục đích lưu trữ và kết nối gia phả dòng họ. Người dùng chịu hoàn toàn trách nhiệm đối với tính chính xác của các thông tin thành viên dòng họ do mình cập nhật.',
            ),
            _buildRegulationSection(
              title: '2. Bảo mật thông tin dòng tộc',
              content:
                  'Chúng tôi cam kết bảo mật thông tin phả hệ của dòng họ bạn. Chỉ những thành viên sở hữu Mã mời hợp lệ do Trưởng tộc cấp mới có quyền truy cập xem thông tin gia phả dòng tộc.',
            ),
            _buildRegulationSection(
              title: '3. Quyền sở hữu và vai trò quản trị',
              content:
                  'Quyền Trưởng tộc là quyền quản lý cao nhất. Trưởng tộc có trách nhiệm phân quyền biên soạn và duyệt yêu cầu gia nhập một cách cẩn trọng để bảo toàn tính toàn vẹn của dữ liệu gia tộc.',
            ),
            _buildRegulationSection(
              title: '4. Giới hạn trách nhiệm',
              content:
                  'Trong trường hợp Trưởng tộc chủ động giải tán hoặc xóa bỏ dòng họ, hệ thống sẽ thực thi xóa dữ liệu vĩnh viễn và không chịu trách nhiệm phục hồi dữ liệu bị mất do thao tác này.',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildRegulationSection(
      {required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.crimson,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: GoogleFonts.inter(
              fontSize: 12,
              height: 1.6,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
