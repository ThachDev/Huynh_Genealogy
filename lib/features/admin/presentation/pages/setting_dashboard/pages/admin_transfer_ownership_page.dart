import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/app_button.dart';
import '../../../../../../core/widgets/app_dialog.dart';
import '../../../../../../core/widgets/app_snackbar.dart';

class AdminTransferOwnershipPage extends StatefulWidget {
  const AdminTransferOwnershipPage({super.key});

  @override
  State<AdminTransferOwnershipPage> createState() =>
      _AdminTransferOwnershipPageState();
}

class _AdminTransferOwnershipPageState
    extends State<AdminTransferOwnershipPage> {
  int? _selectedIndex;

  // Mock list of eligible members to receive ownership transfer
  final List<Map<String, String>> _candidates = [
    {
      'name': 'Huỳnh Quốc Bảo',
      'role': 'Biên soạn',
      'email': 'quocbao.huynh@gmail.com',
    },
    {
      'name': 'Huỳnh Gia Bách',
      'role': 'Thành viên',
      'email': 'giabach.huynh@gmail.com',
    },
    {
      'name': 'Huỳnh Thị Mai Anh',
      'role': 'Biên soạn',
      'email': 'maianh.huynh@gmail.com',
    },
  ];

  void _confirmTransfer() {
    if (_selectedIndex == null) return;
    final candidate = _candidates[_selectedIndex!];

    AppDialog.confirm(
      context,
      title: 'Xác nhận chuyển nhượng',
      message:
          'Bạn có chắc chắn muốn chuyển giao quyền Trưởng tộc cho ${candidate['name']}? Hành động này sẽ thay đổi vai trò của bạn thành Thành viên và không thể hoàn tác.',
      confirmLabel: 'ĐỒNG Ý CHUYỂN',
      cancelLabel: 'HỦY BỎ',
      type: AppDialogType.danger,
    ).then((confirmed) async {
      if (confirmed == true) {
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) {
          AppSnackBar.success(
              context, 'Chuyển nhượng quyền Trưởng tộc thành công!');
          Navigator.pop(context); // Return from page
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        title: const Text('CHUYỂN NHƯỢNG TRƯỞNG TỘC'),
        backgroundColor: AppColors.wood,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Danger Notice Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: AppColors.error.withValues(alpha: 0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(LucideIcons.alertTriangle,
                      color: AppColors.error, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cảnh báo quan trọng',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.error,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Quyền Trưởng tộc là quyền hạn cao nhất trong hệ thống gia phả. Khi chuyển nhượng thành công, bạn sẽ mất quyền chỉnh sửa cấu trúc dòng họ cao cấp và các thiết lập bảo mật.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.error.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Chọn người nhận quyền',
              style: GoogleFonts.beVietnamPro(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Chỉ những thành viên đã kích hoạt tài khoản trong gia phả mới xuất hiện trong danh sách dưới đây:',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side:
                      BorderSide(color: AppColors.gold.withValues(alpha: 0.15)),
                ),
                child: ListView.separated(
                  itemCount: _candidates.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.gold.withValues(alpha: 0.05),
                  ),
                  itemBuilder: (context, index) {
                    final candidate = _candidates[index];

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.wood.withValues(alpha: 0.08),
                        child: Text(
                          candidate['name']![0].toUpperCase(),
                          style: GoogleFonts.beVietnamPro(
                            fontWeight: FontWeight.bold,
                            color: AppColors.wood,
                          ),
                        ),
                      ),
                      title: Text(
                        candidate['name']!,
                        style: GoogleFonts.beVietnamPro(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        '${candidate['role']} • ${candidate['email']}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      trailing: Radio<int>(
                        value: index,
                        // ignore: deprecated_member_use
                        groupValue: _selectedIndex,
                        activeColor: AppColors.crimson,
                        // ignore: deprecated_member_use
                        onChanged: (val) =>
                            setState(() => _selectedIndex = val),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'TIẾN HÀNH CHUYỂN NHƯỢNG',
              onPressed: _selectedIndex != null ? _confirmTransfer : null,
              fullWidth: true,
              size: AppButtonSize.large,
              variant: AppButtonVariant.primary,
            ),
          ],
        ),
      ),
    );
  }
}
