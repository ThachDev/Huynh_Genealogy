import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/components/theme/app_theme.dart';
import 'package:app_family_tree/components/app_bar/app_bar.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/widgets/tree_background_painter.dart';

class SecurityPolicyPage extends StatelessWidget {
  const SecurityPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: const CommonAppBar(
        titleText: 'Chính sách bảo mật',
        centerTitle: true,
      ),
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
                _buildPolicySection(
                  '1. Thông tin được lưu trữ',
                  'Ứng dụng lưu giữ các thông tin cơ bản của thành viên trong dòng họ như: Họ tên, giới tính, ngày sinh, ngày mất và mối quan hệ gia đình nhằm phục vụ việc xây dựng và duy trì gia phả.',
                ),
                const SizedBox(height: 24),
                _buildPolicySection(
                  '2. Mục đích sử dụng',
                  'Toàn bộ thông tin chỉ được sử dụng trong phạm vi nội bộ dòng họ, nhằm giúp con cháu theo dõi phả hệ, kết nối các thế hệ và gìn giữ truyền thống gia đình. Không sử dụng cho mục đích thương mại.',
                ),
                const SizedBox(height: 24),
                _buildPolicySection(
                  '3. Bảo quản thông tin',
                  'Dữ liệu gia phả được lưu trữ cẩn thận và chỉ những người được tin cậy trong dòng họ mới có quyền cập nhật hoặc chỉnh sửa thông tin.',
                ),
                const SizedBox(height: 24),
                _buildPolicySection(
                  '4. Quyền của thành viên',
                  'Mỗi thành viên có thể đề nghị bổ sung hoặc điều chỉnh thông tin của bản thân và người thân thông qua người quản lý gia phả của dòng họ.',
                ),
                const SizedBox(height: 24),
                _buildPolicySection(
                  '5. Cập nhật nội dung',
                  'Thông tin và nội dung trong ứng dụng có thể được cập nhật theo thời gian để đảm bảo chính xác và đầy đủ hơn, và sẽ được thông báo đến các thành viên khi cần thiết.',
                ),
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    'Cập nhật lần cuối: Tháng 3, 2026',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicySection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.crimson,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textPrimary,
            height: 1.6,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
