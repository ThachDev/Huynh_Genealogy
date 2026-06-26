import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/app_snackbar.dart';

class AdminDissolveClanPage extends StatefulWidget {
  const AdminDissolveClanPage({super.key});

  @override
  State<AdminDissolveClanPage> createState() => _AdminDissolveClanPageState();
}

class _AdminDissolveClanPageState extends State<AdminDissolveClanPage> {
  final _confirmController = TextEditingController();
  final String _clanName = 'Huỳnh Gia Tộc';
  bool _canDissolve = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _confirmController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _confirmController.removeListener(_onTextChanged);
    _confirmController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _canDissolve = _confirmController.text.trim() == _clanName;
    });
  }

  void _dissolveClan() {
    if (!_canDissolve) return;

    AppDialog.confirm(
      context,
      title: 'XÓA GIA PHẢ VĨNH VIỄN',
      message: 'Hành động này cực kỳ nguy hiểm. Toàn bộ thông tin thành viên, các nhánh dòng họ, lịch sử gia tộc của "$_clanName" sẽ bị xóa vĩnh viễn khỏi máy chủ. Bạn chắc chắn muốn tiếp tục chứ?',
      confirmLabel: 'ĐỒNG Ý XÓA BỎ',
      cancelLabel: 'HỦY BỎ',
      type: AppDialogType.danger,
    ).then((confirmed) async {
      if (confirmed == true) {
        setState(() => _isSaving = true);
        await Future.delayed(const Duration(milliseconds: 1200));
        if (mounted) {
          setState(() => _isSaving = false);
          AppSnackBar.success(context, 'Đã giải tán gia phả thành công.');
          Navigator.pop(context); // Return from settings
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        title: const Text('GIẢI TÁN GIA PHẢ'),
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
            // Severe Warning Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(LucideIcons.alertOctagon, color: AppColors.error, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Khu vực nguy hiểm tối cao',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.error,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Hành động giải tán gia phả là KHÔNG THỂ HOÀN TÁC. Tất cả cây gia phả, thông tin của tất cả các đời, liên kết thành viên và tài khoản quản trị liên quan sẽ bị xóa sạch khỏi hệ thống.',
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
            const SizedBox(height: 32),
            Text(
              'Để xác nhận, vui lòng nhập chính xác tên dòng họ bên dưới:',
              style: GoogleFonts.beVietnamPro(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.wood.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.gold.withValues(alpha: 0.1)),
              ),
              child: Row(
                children: [
                  Text(
                    'Tên chính xác: ',
                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  Text(
                    _clanName,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.crimson,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            AppTextFieldLight(
              controller: _confirmController,
              label: 'Nhập lại tên dòng họ',
              hintText: 'Nhập đúng từng chữ để xác nhận',
              prefixIcon: const Icon(LucideIcons.trash2, color: AppColors.error),
            ),
            const SizedBox(height: 32),
            AppButton(
              label: 'GIẢI TÁN DÒNG HỌ VĨNH VIỄN',
              onPressed: _canDissolve ? _dissolveClan : null,
              isLoading: _isSaving,
              fullWidth: true,
              size: AppButtonSize.large,
              variant: AppButtonVariant.danger,
            ),
          ],
        ),
      ),
    );
  }
}
