import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_route_transitions.dart';
import '../../../auth/auth.dart';

import 'admin_clan_info_settings_page.dart';
import 'admin_edit_profile_page.dart';
import 'admin_language_settings_page.dart';
import 'admin_account_security_page.dart';
import 'admin_transfer_ownership_page.dart';
import 'admin_dissolve_clan_page.dart';
import 'admin_regulations_page.dart';
import 'admin_theme_settings_page.dart';
import 'admin_help_center_page.dart';
import 'admin_about_us_page.dart';

class AdminSettingsPage extends StatelessWidget {
  const AdminSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        title: const Text('CÀI ĐẶT QUẢN TRỊ'),
        backgroundColor: AppColors.wood,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          _buildSectionHeader(context, 'TÀI KHOẢN VÀ DÒNG TỘC'),
          _buildSettingsCard(children: [
            _buildSettingsTile(
              context: context,
              icon: LucideIcons.home,
              title: 'Thông tin dòng tộc',
              destination: const AdminClanInfoSettingsPage(),
            ),
            _buildDivider(),
            _buildSettingsTile(
              context: context,
              icon: LucideIcons.user,
              title: 'Chỉnh sửa người dùng',
              destination: const AdminEditProfilePage(),
            ),
            _buildDivider(),
            _buildSettingsTile(
              context: context,
              icon: LucideIcons.lock,
              title: 'Bảo mật tài khoản',
              destination: const AdminAccountSecurityPage(),
            ),
          ]),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'THIẾT LẬP ỨNG DỤNG'),
          _buildSettingsCard(children: [
            _buildSettingsTile(
              context: context,
              icon: LucideIcons.globe,
              title: 'Ngôn ngữ',
              destination: const AdminLanguageSettingsPage(),
            ),
            _buildDivider(),
            _buildSettingsTile(
              context: context,
              icon: LucideIcons.palette,
              title: 'Giao diện',
              destination: const AdminThemeSettingsPage(),
            ),
          ]),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'THÔNG TIN & TRỢ GIÚP'),
          _buildSettingsCard(children: [
            _buildSettingsTile(
              context: context,
              icon: LucideIcons.fileText,
              title: 'Quy định & Điều khoản',
              destination: const AdminRegulationsPage(),
            ),
            _buildDivider(),
            _buildSettingsTile(
              context: context,
              icon: LucideIcons.helpCircle,
              title: 'Trung tâm hỗ trợ',
              destination: const AdminHelpCenterPage(),
            ),
            _buildDivider(),
            _buildSettingsTile(
              context: context,
              icon: LucideIcons.info,
              title: 'Về chúng tôi',
              destination: const AdminAboutUsPage(),
            ),
          ]),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'QUẢN TRỊ NÂNG CAO'),
          _buildSettingsCard(children: [
            _buildSettingsTile(
              context: context,
              icon: LucideIcons.shieldAlert,
              title: 'Chuyển nhượng quyền Trưởng tộc',
              destination: const AdminTransferOwnershipPage(),
            ),
            _buildDivider(),
            _buildSettingsTile(
              context: context,
              icon: LucideIcons.trash2,
              title: 'Giải tán dòng họ',
              destination: const AdminDissolveClanPage(),
              titleColor: AppColors.error,
              iconColor: AppColors.error,
            ),
          ]),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(LucideIcons.logOut, size: 18),
            label: Text(
              'ĐĂNG XUẤT',
              style: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.beVietnamPro(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary.withValues(alpha: 0.7),
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.gold.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      color: Colors.white,
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget destination,
    Color? titleColor,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(FadeScalePageRoute(page: destination));
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.crimson).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: iconColor ?? AppColors.crimson,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: titleColor ?? AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              size: 16,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.gold.withValues(alpha: 0.05),
      indent: 60,
      endIndent: 16,
    );
  }
}
