import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/domain/entity/family_entity.dart';
import '../../../../auth/auth.dart';
import '../../bloc/admin_pending_requests/admin_pending_requests_bloc.dart';

import 'pages/admin_clan_info_settings_page.dart';
import 'pages/admin_edit_profile_page.dart';
import 'pages/admin_account_security_page.dart';
import 'pages/admin_transfer_ownership_page.dart';
import 'pages/admin_dissolve_clan_page.dart';
import 'pages/admin_regulations_page.dart';
import 'pages/admin_help_center_page.dart';
import 'pages/admin_about_us_page.dart';
import 'pages/admin_member_roles_page.dart';

import '../../../../../main.dart';

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  bool _isEn = false;
  bool _isDark = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    final brightness = Theme.of(context).brightness;
    setState(() {
      _isEn = locale.languageCode == 'en';
      _isDark = brightness == Brightness.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pendingState = context.watch<AdminPendingRequestsBloc>().state;
    final FamilyEntity? family =
        pendingState is AdminPendingRequestsLoaded ? pendingState.family : null;
    final authState = context.watch<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;

    final role = user?.role ?? 'VIEWER';
    final roleUpper = role.toUpperCase();
    final isOwner = roleUpper == 'OWNER' || roleUpper == 'CREATOR';
    final isEditor = roleUpper == 'EDITOR';

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
          _buildSettingsCard(children: [
            _buildSectionHeaderInsideCard(context, 'TÀI KHOẢN VÀ DÒNG TỘC'),
            if (!isEditor) ...[
              _buildSettingsTile(
                context: context,
                icon: LucideIcons.home,
                title: 'Thông tin dòng tộc',
                destination: AdminClanInfoSettingsPage(family: family),
              ),
            ],
            _buildSettingsTile(
              context: context,
              icon: LucideIcons.user,
              title: 'Chỉnh sửa người dùng',
              destination: AdminEditProfilePage(user: user),
            ),
            _buildSettingsTile(
              context: context,
              icon: LucideIcons.lock,
              title: 'Bảo mật tài khoản',
              destination: const AdminAccountSecurityPage(),
            ),
            if (isOwner) ...[
              _buildSettingsTile(
                context: context,
                icon: LucideIcons.users,
                title: 'Phân quyền thành viên',
                destination: const AdminMemberRolesPage(),
              ),
            ],
            _buildSettingsTile(
              context: context,
              icon: LucideIcons.userCheck,
              title: 'Chuyển sang trang Thành viên',
              onTap: () {
                UserMainNavigationPage.adminModeNotifier.value = false;
              },
            ),
            _buildSectionHeaderInsideCard(context, 'THIẾT LẬP ỨNG DỤNG'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.globe,
                        size: 22,
                        color: AppColors.crimson,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Ngôn ngữ',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  AppCustomSwitch(
                    value: _isEn,
                    activeColor: AppColors.crimson,
                    inactiveColor: AppColors.crimson,
                    onChanged: (val) {
                      setState(() {
                        _isEn = val;
                      });
                      final newLang = val ? 'en' : 'vi';
                      FamilyTreeApp.setLocale(context, Locale(newLang));
                    },
                    activeText: 'EN',
                    inactiveText: 'VI',
                    activeIcon:
                        const Text('🇺🇸', style: TextStyle(fontSize: 16)),
                    inactiveIcon:
                        const Text('🇻🇳', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.palette,
                        size: 22,
                        color: AppColors.crimson,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Giao diện',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  AppCustomSwitch(
                    value: _isDark,
                    activeColor: AppColors.crimson,
                    inactiveColor: AppColors.crimson,
                    onChanged: (val) {
                      setState(() {
                        _isDark = val;
                      });
                      final mode = val ? ThemeMode.dark : ThemeMode.light;
                      FamilyTreeApp.setThemeMode(context, mode);
                    },
                    activeText: 'Dark',
                    inactiveText: 'Light',
                    activeIcon: const Icon(LucideIcons.moon,
                        size: 14, color: AppColors.crimson),
                    inactiveIcon: const Icon(LucideIcons.sun,
                        size: 14, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
            _buildSectionHeaderInsideCard(context, 'THÔNG TIN & TRỢ GIÚP'),
            _buildSettingsTile(
              context: context,
              icon: LucideIcons.fileText,
              title: 'Quy định & Điều khoản',
              destination: const AdminRegulationsPage(),
            ),
            _buildSettingsTile(
              context: context,
              icon: LucideIcons.helpCircle,
              title: 'Trung tâm hỗ trợ',
              destination: const AdminHelpCenterPage(),
            ),
            _buildSettingsTile(
              context: context,
              icon: LucideIcons.info,
              title: 'Về chúng tôi',
              destination: const AdminAboutUsPage(),
            ),
            if (isOwner) ...[
              _buildSectionHeaderInsideCard(context, 'QUẢN TRỊ NÂNG CAO'),
              _buildSettingsTile(
                context: context,
                icon: LucideIcons.shieldAlert,
                title: 'Chuyển nhượng quyền Trưởng tộc',
                destination: const AdminTransferOwnershipPage(),
              ),
              _buildSettingsTile(
                context: context,
                icon: LucideIcons.trash2,
                title: 'Giải tán dòng họ',
                destination: const AdminDissolveClanPage(),
                titleColor: AppColors.error,
                iconColor: AppColors.error,
              ),
            ],
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
    Widget? destination,
    VoidCallback? onTap,
    Color? titleColor,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap();
        } else if (destination != null) {
          Navigator.of(context).push(FadeScalePageRoute(page: destination));
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: iconColor ?? AppColors.crimson,
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

  Widget _buildSectionHeaderInsideCard(BuildContext context, String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, top: 20, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.beVietnamPro(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AppColors.crimson,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
