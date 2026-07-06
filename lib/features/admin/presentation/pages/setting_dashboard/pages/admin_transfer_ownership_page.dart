import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:giatocviet/core/theme/app_theme.dart';
import 'package:giatocviet/core/widgets/app_button.dart';
import 'package:giatocviet/core/widgets/app_snackbar.dart';
import 'package:giatocviet/features/auth/auth.dart';
import 'package:giatocviet/features/admin/admin.dart';

class AdminTransferOwnershipPage extends StatefulWidget {
  const AdminTransferOwnershipPage({super.key});

  @override
  State<AdminTransferOwnershipPage> createState() =>
      _AdminTransferOwnershipPageState();
}

class _AdminTransferOwnershipPageState
    extends State<AdminTransferOwnershipPage> {
  int? _selectedIndex;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated && authState.user.familyId != null) {
        context
            .read<AdminTransferOwnershipBloc>()
            .add(LoadCandidatesEvent(familyId: authState.user.familyId!));
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _confirmTransfer(int familyId, int newOwnerUserId, String newOwnerName) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
              color: AppColors.error.withValues(alpha: 0.3), width: 1),
        ),
        title: Row(
          children: [
            const Icon(LucideIcons.alertTriangle,
                color: AppColors.error, size: 22),
            const SizedBox(width: 10),
            Text('Cảnh báo quan trọng',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quyền Trưởng tộc là quyền hạn cao nhất trong hệ thống gia phả. Khi chuyển nhượng thành công, bạn sẽ mất quyền chỉnh sửa cấu trúc dòng họ cao cấp và các thiết lập bảo mật.',
              style: GoogleFonts.inter(
                  fontSize: 13, color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Bạn có chắc chắn muốn chuyển giao quyền Trưởng tộc cho $newOwnerName?',
              style: GoogleFonts.inter(
                  fontSize: 13, color: Colors.white60, height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('HỦY BỎ',
                style: GoogleFonts.inter(
                    color: Colors.white60,
                    fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 14),
            ),
            child: Text('ĐỒNG Ý CHUYỂN',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        context.read<AdminTransferOwnershipBloc>().add(
              TransferOwnershipEvent(
                familyId: familyId,
                newOwnerUserId: newOwnerUserId,
              ),
            );
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
      body:
          BlocConsumer<AdminTransferOwnershipBloc, AdminTransferOwnershipState>(
        listener: (context, state) {
          if (state is AdminTransferOwnershipSuccess) {
            AppSnackBar.success(
                context, 'Chuyển nhượng quyền Trưởng tộc thành công!');
            Navigator.pop(context);
          } else if (state is AdminTransferOwnershipFailure) {
            AppSnackBar.error(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is AdminTransferOwnershipLoading ||
              state is AdminTransferOwnershipInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.wood),
            );
          }

          if (state is AdminTransferOwnershipFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.alertCircle,
                        color: AppColors.error, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.beVietnamPro(
                        color: AppColors.error,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      label: 'THỬ LẠI',
                      onPressed: () {
                        final authState = context.read<AuthBloc>().state;
                        if (authState is Authenticated &&
                            authState.user.familyId != null) {
                          context.read<AdminTransferOwnershipBloc>().add(
                                LoadCandidatesEvent(
                                    familyId: authState.user.familyId!),
                              );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is AdminTransferOwnershipSubmitting) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: AppColors.wood),
                  SizedBox(height: 16),
                  Text('Đang xử lý chuyển nhượng...'),
                ],
              ),
            );
          }

          final candidates = state is AdminTransferOwnershipLoaded
              ? state.candidates
              : <dynamic>[];

          if (candidates.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.users,
                        color: AppColors.textSecondary, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Không có thành viên nào đủ điều kiện nhận chuyển nhượng.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.beVietnamPro(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final query = _searchController.text.trim().toLowerCase();
          final filtered = query.isEmpty
              ? candidates
              : candidates
                  .where((c) => (c.userFullName ?? '')
                      .toLowerCase()
                      .contains(query))
                  .toList();

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  'Chỉ những thành viên đã kích hoạt tài khoản và có vai trò khác Trưởng tộc mới xuất hiện trong danh sách dưới đây:',
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
                      side: BorderSide(
                          color: AppColors.gold.withValues(alpha: 0.15)),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Tìm thành viên...',
                              hintStyle: GoogleFonts.inter(fontSize: 13),
                              prefixIcon: const Icon(LucideIcons.search,
                                  size: 18, color: AppColors.textSecondary),
                              isDense: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: AppColors.gold
                                        .withValues(alpha: 0.2)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: AppColors.gold
                                        .withValues(alpha: 0.2)),
                              ),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        Expanded(
                          child: filtered.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(
                                      'Không tìm thấy thành viên phù hợp.',
                                      style: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: AppColors.textSecondary),
                                    ),
                                  ),
                                )
                              : RadioGroup<int>(
                                  groupValue: _selectedIndex,
                                  onChanged: (val) =>
                                      setState(() => _selectedIndex = val),
                                  child: ListView.separated(
                                    itemCount: filtered.length,
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: AppColors.gold
                                          .withValues(alpha: 0.05),
                                    ),
                                    itemBuilder: (context, index) {
                                      final candidate = filtered[index];

                                      return ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                        leading: CircleAvatar(
                                          backgroundColor: AppColors.wood
                                              .withValues(alpha: 0.08),
                                          backgroundImage:
                                              candidate.userAvatarUrl != null
                                                  ? NetworkImage(
                                                      candidate.userAvatarUrl!)
                                                  : null,
                                          child: candidate.userAvatarUrl == null
                                              ? Text(
                                                  (candidate.userFullName ??
                                                          'U')[0]
                                                      .toUpperCase(),
                                                  style:
                                                      GoogleFonts.beVietnamPro(
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.wood,
                                                  ),
                                                )
                                              : null,
                                        ),
                                        title: Text(
                                          candidate.userFullName ??
                                              'Thành viên',
                                          style: GoogleFonts.beVietnamPro(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        subtitle: Text(
                                          '${AdminDashboardPage.roleLabel(candidate.role)} • ${candidate.userEmail ?? 'Chưa có email'}',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        trailing: Radio<int>(value: index),
                                      );
                                    },
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: 'TIẾN HÀNH CHUYỂN NHƯỢNG',
                  onPressed: _selectedIndex != null
                      ? () {
                          final authState = context.read<AuthBloc>().state;
                          if (authState is Authenticated &&
                              authState.user.familyId != null) {
                            final candidate = filtered[_selectedIndex!];
                            _confirmTransfer(
                              authState.user.familyId!,
                              candidate.userId,
                              candidate.userFullName ?? 'Thành viên',
                            );
                          }
                        }
                      : null,
                  fullWidth: true,
                  size: AppButtonSize.large,
                  variant: AppButtonVariant.primary,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
