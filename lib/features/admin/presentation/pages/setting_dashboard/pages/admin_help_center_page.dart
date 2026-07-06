import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/app_snackbar.dart';

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
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, 'Liên hệ trực tiếp'),
            const SizedBox(height: 16),
            _buildContactRow(context),
            const SizedBox(height: 32),
            _buildSectionTitle(context, 'Tài khoản & Đăng nhập'),
            const SizedBox(height: 16),
            _buildFaqItem(
              question: 'Làm sao để đăng ký tài khoản?',
              answer:
                  'Tải ứng dụng Gia Tộc Việt từ CH Play (Android). Mở ứng dụng, nhấn "Đăng ký" và điền đầy đủ họ tên, email, số điện thoại và mật khẩu.',
            ),
            _buildFaqItem(
              question: 'Tôi quên mật khẩu, phải làm sao?',
              answer:
                  'Trên màn hình đăng nhập, nhấn "Quên mật khẩu". Nhập email đã đăng ký, hệ thống sẽ gửi mã OTP gồm 6 chữ số qua email. Nhập mã OTP để xác thực, sau đó tạo mật khẩu mới.',
            ),
            _buildFaqItem(
              question: 'Làm sao để đổi mật khẩu?',
              answer:
                  'Vào Cài đặt > Bảo mật tài khoản, nhập mật khẩu hiện tại, sau đó nhập mật khẩu mới và xác nhận. Mật khẩu mới phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số.',
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Gia phả & Thành viên'),
            const SizedBox(height: 16),
            _buildFaqItem(
              question: 'Làm sao để thêm thành viên mới?',
              answer:
                  'Vào Dashboard > Quản lý thành viên, nhấn nút "Thêm thành viên". Điền đầy đủ thông tin: họ tên, giới tính, ngày sinh, nơi sinh, thế hệ, chi tộc, cha/mẹ (nếu có). Bạn có thể thêm thông tin chi tiết như ngày mất, tình trạng hôn nhân, số điện thoại, ghi chú. Nhấn "Lưu" để hoàn tất.',
            ),
            _buildFaqItem(
              question: 'Làm sao để thêm nhánh (chi tộc) mới?',
              answer:
                  'Vào Dashboard > Quản lý chi tộc, nhấn "Thêm chi tộc". Điền tên chi tộc, mô tả và thông tin người sáng lập (nếu có). Sau khi tạo, bạn có thể phân quyền Quản trị chi cho thành viên phụ trách nhánh đó.',
            ),
            _buildFaqItem(
              question: 'Làm sao để chỉnh sửa thông tin thành viên?',
              answer:
                  'Vào Dashboard > Quản lý thành viên, chọn thành viên cần chỉnh sửa. Nhấn vào biểu tượng chỉnh sửa (bút) để cập nhật thông tin. Lưu ý: chỉ Biên tập viên và các vai trò cao hơn mới có quyền chỉnh sửa.',
            ),
            _buildFaqItem(
              question: 'Làm sao để xóa thành viên?',
              answer:
                  'Chọn thành viên trong danh sách, nhấn biểu tượng xóa (thùng rác). Một hộp thoại xác nhận sẽ hiện ra. Lưu ý: chỉ Trưởng tộc và Quản trị chi mới có quyền xóa thành viên. Biên tập viên không có quyền này.',
            ),
            _buildFaqItem(
              question: 'Nhập gia phả từ file được không?',
              answer:
                  'Ứng dụng hiện hỗ trợ thêm từng thành viên thủ công. Tính năng nhập hàng loạt từ file đang được phát triển.',
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Dòng tộc & Phân quyền'),
            const SizedBox(height: 16),
            _buildFaqItem(
              question: 'Mã mời gia tộc hoạt động như thế nào?',
              answer:
                  'Mỗi Dòng tộc có một Mã mời duy nhất do hệ thống tạo. Trưởng tộc có thể xem, sao chép hoặc chia sẻ Mã mời qua QR code trong Dashboard. Thành viên mới nhập mã này khi đăng ký hoặc trong mục "Tham gia gia tộc" để gửi yêu cầu gia nhập. Trưởng tộc hoặc Quản trị chi sẽ phê duyệt yêu cầu trước khi thành viên có thể truy cập.',
            ),
            _buildFaqItem(
              question: 'Các vai trò trong Dòng tộc là gì?',
              answer: 'Hệ thống có 4 cấp vai trò:\n'
                  '• Trưởng tộc — Quyền cao nhất, quản lý toàn bộ Dòng tộc, phân quyền và giải tán.\n'
                  '• Quản trị chi — Quản lý một hoặc nhiều nhánh, phê duyệt yêu cầu gia nhập.\n'
                  '• Biên tập viên — Thêm và chỉnh sửa thông tin thành viên, không được xóa.\n'
                  '• Thành viên — Xem thông tin gia phả, không được chỉnh sửa.',
            ),
            _buildFaqItem(
              question: 'Làm sao để phân quyền cho thành viên?',
              answer:
                  'Vào Cài đặt > Phân quyền thành viên (chỉ Trưởng tộc mới thấy mục này). Chọn thành viên cần thay đổi vai trò và chọn cấp quyền tương ứng. Trưởng tộc không thể tự hạ cấp vai trò của mình — cần sử dụng tính năng Chuyển nhượng quyền Trưởng tộc.',
            ),
            _buildFaqItem(
              question: 'Làm sao để chuyển nhượng quyền Trưởng tộc?',
              answer:
                  'Vào Cài đặt > Chuyển nhượng quyền Trưởng tộc. Chọn thành viên đã kích hoạt tài khoản từ danh sách. Xác nhận chuyển nhượng — thao tác này không thể hoàn tác. Sau khi chuyển nhượng, bạn sẽ trở thành Thành viên và người nhận trở thành Trưởng tộc mới.',
            ),
            _buildFaqItem(
              question: 'Làm sao để giải tán dòng tộc?',
              answer:
                  'Vào Cài đặt > Giải tán dòng họ (chỉ Trưởng tộc). Gõ chính xác tên Dòng tộc để xác nhận. Toàn bộ dữ liệu bao gồm thành viên, nhánh, gia phả và quỹ gia tộc sẽ bị xóa vĩnh viễn khỏi hệ thống và không thể khôi phục. Cân nhắc kỹ trước khi thực hiện.',
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Kỹ thuật & Bảo mật'),
            const SizedBox(height: 16),
            _buildFaqItem(
              question: 'Dữ liệu gia phả của tôi có được bảo mật không?',
              answer:
                  'Có. Toàn bộ dữ liệu được lưu trữ trên máy chủ đặt tại Việt Nam, áp dụng mã hóa đầu cuối TLS 1.3 khi truyền tải và mã hóa AES-256 khi lưu trữ. Chúng tôi tuân thủ nghiêm ngặt Nghị định 13/2023/NĐ-CP về bảo vệ dữ liệu cá nhân và cam kết không bán, chia sẻ dữ liệu cho bên thứ ba.',
            ),
            _buildFaqItem(
              question: 'Làm sao để xóa tài khoản?',
              answer:
                  'Vào Cài đặt > Bảo mật tài khoản, chọn "Xóa tài khoản". Xác nhận yêu cầu xóa. Dữ liệu cá nhân của bạn sẽ được xóa khỏi hệ thống trong vòng 30 ngày. Lưu ý: nếu bạn là Trưởng tộc, cần chuyển nhượng quyền Trưởng tộc hoặc giải tán Dòng tộc trước khi xóa tài khoản.',
            ),
            _buildFaqItem(
              question:
                  'Tôi có thể sử dụng ứng dụng trên nhiều thiết bị không?',
              answer:
                  'Có. Tài khoản của bạn có thể đăng nhập trên nhiều thiết bị cùng lúc. Dữ liệu sẽ được đồng bộ hóa theo thời gian thực. Tuy nhiên, vì lý do bảo mật, bạn nên đăng xuất khỏi thiết bị không sử dụng.',
            ),
            _buildFaqItem(
              question: 'Ứng dụng có hỗ trợ tiếng Anh không?',
              answer:
                  'Có. Vào Cài đặt > Ngôn ngữ, chuyển đổi giữa Tiếng Việt và Tiếng Anh. Giao diện sẽ cập nhật ngay lập tức. Dữ liệu gia phả và thông tin thành viên vẫn được giữ nguyên.',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.crimson,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.beVietnamPro(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.wood,
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildContactCard(
            context: context,
            icon: LucideIcons.phoneCall,
            title: 'Hotline hỗ trợ',
            value: '1900 8888',
            subtitle: '8:00 - 17:30 (T2-T6)',
            onTap: () {
              AppSnackBar.info(
                context,
                'Đang chuẩn bị kết nối cuộc gọi tới 1900 8888',
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: _buildContactCard(
            context: context,
            icon: LucideIcons.mail,
            title: 'Email hỗ trợ',
            value: 'thachhuynh.dev@gmail.com',
            subtitle: 'Phản hồi trong 24h',
            onTap: () {
              AppSnackBar.info(
                context,
                'Đang mở ứng dụng email gửi tới thachhuynh.dev@gmail.com',
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContactCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
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
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.crimson,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem({
    required String question,
    required String answer,
  }) {
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
        collapsedShape: const RoundedRectangleBorder(),
        shape: const RoundedRectangleBorder(),
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        children: [
          Text(
            answer,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
