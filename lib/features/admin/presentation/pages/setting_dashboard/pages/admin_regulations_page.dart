import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                'assets/images/logo_launcher.png',
                width: 96,
                height: 96,
                fit: BoxFit.contain,
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
                'Cập nhật lần cuối: Tháng 7, 2026',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              number: '1',
              title: 'Chấp thuận',
              content:
                  'Khi tải và sử dụng Gia Tộc Việt, bạn đồng ý với các điều khoản dưới đây và Chính sách bảo mật của chúng tôi. Nếu không đồng ý, vui lòng không dùng ứng dụng.',
            ),
            _buildSection(
              number: '2',
              title: 'Giải thích từ ngữ',
              content:
                  '**Ứng dụng:** Gia Tộc Việt và các tính năng của ứng dụng.\n'
                  '**Người dùng:** Cá nhân đã đăng ký tài khoản.\n'
                  '**Dòng họ:** Nhóm thành viên do Trưởng tộc tạo lập, gồm chi tộc, thành viên và dữ liệu gia phả.\n'
                  '**Trưởng tộc:** Người quản trị cao nhất của dòng họ.\n'
                  '**Quản trị chi:** Người được ủy quyền quản lý một chi tộc.\n'
                  '**Biên tập viên:** Người được phép thêm, sửa thông tin.\n'
                  '**Thành viên:** Người có quyền xem gia phả.\n'
                  '**Dữ liệu cá nhân:** Họ tên, ngày sinh, giới tính, quan hệ gia đình, hình ảnh, số điện thoại, email…',
            ),
            _buildSection(
              number: '3',
              title: 'Tài khoản',
              content:
                  '• Bạn phải đủ 18 tuổi hoặc có người giám hộ hợp pháp.\n'
                  '• Bạn chịu trách nhiệm bảo vệ mật khẩu của mình.\n'
                  '• Mỗi người chỉ được tạo một tài khoản, dùng cho mục đích cá nhân.\n'
                  '• Thông tin đăng ký phải chính xác và trung thực.',
            ),
            _buildSection(
              number: '4',
              title: 'Quyền hạn theo vai trò',
              content:
                  '**Thành viên** – Xem gia phả, quỹ dòng họ, sửa thông tin cá nhân.\n'
                  '**Biên tập viên** – Thêm, sửa thông tin thành viên (không được xóa).\n'
                  '**Quản trị chi** – Quản lý chi tộc, phê duyệt yêu cầu, quản lý quỹ.\n'
                  '**Trưởng tộc** – Toàn quyền quản trị, phân quyền, chuyển nhượng, giải tán.',
            ),
            _buildSection(
              number: '5',
              title: 'Quản trị dòng họ',
              content:
                  'Trưởng tộc có toàn quyền: phê duyệt thành viên, phân vai trò, cập nhật thông tin, chuyển nhượng quyền Trưởng tộc và giải tán dòng họ. Khi chuyển nhượng, Trưởng tộc cũ trở thành Thành viên và không thể lấy lại quyền cũ. Mọi thao tác thêm, sửa, xóa trong hệ thống đều được ghi lại.',
            ),
            _buildSection(
              number: '6',
              title: 'Bảo mật dữ liệu',
              content:
                  'Chúng tôi bảo vệ dữ liệu của bạn theo Luật An ninh mạng Việt Nam và Nghị định 13/2023/NĐ-CP. Dữ liệu được lưu tại máy chủ Việt Nam, mã hóa khi truyền tải và lưu trữ. Chúng tôi không bán dữ liệu của bạn cho bên thứ ba. Thông tin dòng họ chỉ hiển thị cho thành viên đã được phê duyệt.',
            ),
            _buildSection(
              number: '7',
              title: 'Sở hữu trí tuệ',
              content:
                  'Gia Tộc Việt (mã nguồn, thiết kế, thương hiệu, logo) là tài sản của đơn vị phát triển, được bảo hộ theo pháp luật Việt Nam. Dữ liệu gia phả do người dùng tạo ra thuộc quyền sở hữu của dòng họ đó.',
            ),
            _buildSection(
              number: '8',
              title: 'Trách nhiệm',
              content:
                  'Ứng dụng được cung cấp ở trạng thái hiện tại. Chúng tôi không chịu trách nhiệm nếu: (i) bạn sử dụng sai mục đích; (ii) thông tin bạn cung cấp không chính xác; (iii) Trưởng tộc chủ động xóa hoặc giải tán dòng họ. Nếu mất dữ liệu do lỗi hệ thống, chúng tôi sẽ cố gắng khôi phục.',
            ),
            _buildSection(
              number: '9',
              title: 'Xử lý vi phạm',
              content:
                  'Chúng tôi có thể tạm khóa hoặc chấm dứt tài khoản nếu phát hiện vi phạm. Các mức xử lý: cảnh báo, tạm khóa, khóa vĩnh viễn hoặc thông báo cơ quan chức năng nếu vi phạm pháp luật. Trưởng tộc có thể giải tán dòng họ bất kỳ lúc nào — sau khi xác nhận, toàn bộ dữ liệu bị xóa vĩnh viễn và không thể khôi phục.',
            ),
            _buildSection(
              number: '10',
              title: 'Điều khoản chung',
              content:
                  'Các điều khoản này được điều chỉnh theo pháp luật Việt Nam. Mọi tranh chấp được ưu tiên giải quyết qua thương lượng. Chúng tôi có thể sửa đổi điều khoản và sẽ thông báo trên ứng dụng. Nếu bạn tiếp tục dùng ứng dụng sau khi thay đổi, nghĩa là bạn đã chấp nhận điều khoản mới.',
            ),
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

  Widget _buildSection({
    required String number,
    required String title,
    required String content,
  }) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.crimson.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      number,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.crimson,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.wood,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildContent(content),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(String text) {
    final hasBold = text.contains('**');
    if (!hasBold) {
      return Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12,
          height: 1.6,
          color: AppColors.textPrimary,
        ),
      );
    }

    final spans = <InlineSpan>[];
    final regex = RegExp(r'\*\*(.+?)\*\*');
    int lastEnd = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: text.substring(lastEnd, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: GoogleFonts.inter(
          fontSize: 12,
          height: 1.6,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ));
      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd)));
    }

    return Text.rich(
      TextSpan(children: spans),
      style: GoogleFonts.inter(
        fontSize: 12,
        height: 1.6,
        color: AppColors.textPrimary,
      ),
    );
  }
}
