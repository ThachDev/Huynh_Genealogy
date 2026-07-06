import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/app_button.dart';
import '../../../../../../core/widgets/app_text_field.dart';
import '../../../../../../core/widgets/app_dialog.dart';
import '../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../../features/auth/auth.dart';
import '../../../bloc/admin_dissolve_clan_bloc/admin_dissolve_clan_bloc.dart';

class AdminDissolveClanPage extends StatefulWidget {
  final int familyId;
  final String familyName;

  const AdminDissolveClanPage({
    super.key,
    required this.familyId,
    required this.familyName,
  });

  @override
  State<AdminDissolveClanPage> createState() => _AdminDissolveClanPageState();
}

class _AdminDissolveClanPageState extends State<AdminDissolveClanPage> {
  final _confirmController = TextEditingController();
  bool _canDissolve = false;

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
      _canDissolve = _confirmController.text.trim() == widget.familyName;
    });
  }

  void _dissolveClan() {
    if (!_canDissolve) return;

    AppDialog.confirm(
      context,
      title: 'XÓA GIA PHẢ VĨNH VIỄN',
      message:
          'Hành động này cực kỳ nguy hiểm. Toàn bộ thông tin thành viên, các nhánh dòng họ, lịch sử gia tộc của "${widget.familyName}" sẽ bị xóa vĩnh viễn khỏi máy chủ. Bạn chắc chắn muốn tiếp tục chứ?',
      confirmLabel: 'ĐỒNG Ý XÓA BỎ',
      cancelLabel: 'HỦY BỎ',
      type: AppDialogType.danger,
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        context
            .read<AdminDissolveClanBloc>()
            .add(DeleteFamilyRequested(familyId: widget.familyId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminDissolveClanBloc, AdminDissolveClanState>(
      listener: (context, state) {
        if (state is AdminDissolveClanSuccess) {
          final authState = context.read<AuthBloc>().state;
          if (authState is Authenticated) {
            final updatedUser = authState.user.copyWith(
              familyId: null,
              role: 'VIEWER',
            );
            context.read<AuthBloc>().add(AuthUserUpdated(user: updatedUser));
          }
          AppSnackBar.success(
            context,
            'Đã xóa gia phả. Toàn bộ dữ liệu đã được xóa khỏi hệ thống.',
          );
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else if (state is AdminDissolveClanFailure) {
          AppSnackBar.error(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.parchment,
        appBar: AppBar(
          title: const Text('GIẢI TÁN GIA PHẢ'),
          backgroundColor: AppColors.wood,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocBuilder<AdminDissolveClanBloc, AdminDissolveClanState>(
          builder: (context, state) {
            final isLoading = state is AdminDissolveClanLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Card(
                    elevation: 0,
                    color: AppColors.error.withValues(alpha: 0.06),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                          color: AppColors.error.withValues(alpha: 0.2)),
                    ),
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(LucideIcons.alertOctagon,
                                color: AppColors.error, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hành động không thể hoàn tác',
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.error,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Việc này KHÔNG THỂ hoàn tác. Toàn bộ cây gia phả, thông tin các đời, thành viên và dữ liệu sẽ bị xóa vĩnh viễn khỏi hệ thống.',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    height: 1.5,
                                    color:
                                        AppColors.error.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                          color: AppColors.gold.withValues(alpha: 0.1)),
                    ),
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Xác nhận giải tán',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.wood,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Để xác nhận, vui lòng nhập chính xác tên dòng họ bên dưới:',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.crimson.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color:
                                      AppColors.crimson.withValues(alpha: 0.15)),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Nhập: ',
                                  style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.textSecondary),
                                ),
                                Text(
                                  widget.familyName,
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.crimson,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppTextFieldLight(
                            controller: _confirmController,
                            label: 'Nhập lại tên dòng họ',
                            hintText: 'Nhập đúng từng chữ để xác nhận',
                            prefixIcon: const Icon(LucideIcons.trash2,
                                color: AppColors.error),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'GIẢI TÁN DÒNG HỌ VĨNH VIỄN',
                    onPressed: _canDissolve ? _dissolveClan : null,
                    isLoading: isLoading,
                    fullWidth: true,
                    size: AppButtonSize.large,
                    variant: AppButtonVariant.danger,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
