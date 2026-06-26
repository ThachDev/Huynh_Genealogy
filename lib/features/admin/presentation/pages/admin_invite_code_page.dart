import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/auth.dart';
import '../../../user/presentation/bloc/user_tree_bloc.dart';

class AdminInviteCodePage extends StatelessWidget {
  const AdminInviteCodePage({super.key});

  void _copyToClipboard(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
    AppSnackBar.success(context, 'Đã sao chép mã mời: $code');
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;

    // Lấy thông tin họ tộc
    String familyName = 'Gia Tộc';
    String inviteCode = 'HGT-2026'; // Fallback code
    if (user != null) {
      final userTreeState = context.watch<UserTreeBloc>().state;
      if (userTreeState is UserTreeLoaded && userTreeState.members.isNotEmpty) {
        final rootMember = userTreeState.members.firstWhere(
          (m) => m.generation == 1 || m.parentId == null,
          orElse: () => userTreeState.members.first,
        );
        final parts = rootMember.fullName.trim().split(' ');
        if (parts.isNotEmpty) {
          familyName = '${parts.first} Gia Tộc';
        }
      } else {
        final parts = user.fullName.trim().split(' ');
        if (parts.isNotEmpty) {
          familyName = '${parts.first} Gia Tộc';
        }
      }
      inviteCode = 'HGT-${user.familyId ?? 2026}';
    }

    return Scaffold(
      backgroundColor: AppColors.parchment, // Đổi sang Parchment (kem sáng) của hệ thống
      appBar: AppBar(
        backgroundColor: AppColors.wood,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Mã Mời Gia Tộc',
          style: GoogleFonts.beVietnamPro(
            color: AppColors.gold,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sử dụng AppSectionHeader theo kiểu kết nối dòng tộc của viewer_onboarding_widget
              AppSectionHeader(
                title: "Chia sẻ mã mời",
                description: "Mời thành viên gia đình tham gia cây gia phả bằng mã hoặc quét QR dưới đây.",
                titleSize: 20,
                indicatorHeight: 20,
                spacing: 8,
              ),
              const SizedBox(height: 28),

              // Thẻ Card màu trắng sáng (AppColors.surface) giống card của viewer_onboarding
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.3),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TÊN GIA TỘC',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.crimson,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      familyName.toUpperCase(),
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'MÃ THAM GIA',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.crimson,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // Hộp hiển thị code giống viewer_onboarding
                        Expanded(
                          child: Container(
                            height: 52,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: AppColors.parchment.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: AppColors.textSecondary.withValues(alpha: 0.15),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                inviteCode,
                                style: GoogleFonts.inter(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Nút Copy
                        GestureDetector(
                          onTap: () => _copyToClipboard(context, inviteCode),
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppColors.parchment.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: AppColors.textSecondary.withValues(alpha: 0.15),
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                LucideIcons.copy,
                                color: AppColors.crimson,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Phân tách giữa Code và QR
                    Row(
                      children: [
                        const Expanded(child: Divider(color: Colors.black12)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(
                            LucideIcons.qrCode,
                            color: AppColors.gold.withValues(alpha: 0.8),
                            size: 16,
                          ),
                        ),
                        const Expanded(child: Divider(color: Colors.black12)),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // QR Code
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.gold,
                            width: 1.5,
                          ),
                        ),
                        child: QrImageView(
                          data: inviteCode,
                          version: QrVersions.auto,
                          size: 160.0,
                          gapless: false,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Nút hành động
                    AppButton(
                      label: 'LƯU MÃ QR VỀ MÁY',
                      onPressed: () {
                        AppSnackBar.info(context, 'Tính năng tải mã QR đang được phát triển');
                      },
                      fullWidth: true,
                      size: AppButtonSize.large,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
