import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import 'admin_dashboard_page.dart';

class AdminMemberRolesPage extends StatefulWidget {
  const AdminMemberRolesPage({super.key});

  @override
  State<AdminMemberRolesPage> createState() => _AdminMemberRolesPageState();
}

class _AdminMemberRolesPageState extends State<AdminMemberRolesPage> {
  // Mock list of users in the family tree with roles
  final List<Map<String, dynamic>> _users = [
    {
      'id': 1,
      'fullName': 'Huỳnh Kim Hùng',
      'email': 'kimhung.huynh@gmail.com',
      'role': 'OWNER',
      'avatarUrl': null,
    },
    {
      'id': 2,
      'fullName': 'Huỳnh Thế Anh',
      'email': 'theanh.huynh@gmail.com',
      'role': 'BRANCH_ADMIN',
      'avatarUrl': null,
    },
    {
      'id': 3,
      'fullName': 'Huỳnh Mỹ Linh',
      'email': 'mylinh.huynh@gmail.com',
      'role': 'EDITOR',
      'avatarUrl': null,
    },
    {
      'id': 4,
      'fullName': 'Huỳnh Minh Triết',
      'email': 'minhtriet.huynh@gmail.com',
      'role': 'VIEWER',
      'avatarUrl': null,
    },
    {
      'id': 5,
      'fullName': 'Huỳnh Quốc Bảo',
      'email': 'quocbao.huynh@gmail.com',
      'role': 'VIEWER',
      'avatarUrl': null,
    },
  ];

  void _showRoleSelector(int index) {
    final user = _users[index];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.parchment,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    'Thay đổi vai trò cho ${user['fullName']}',
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const Divider(),
                _buildRoleOption(index, 'OWNER', 'Trưởng tộc', 'Toàn quyền cấu hình và bàn giao gia tộc.'),
                _buildRoleOption(index, 'BRANCH_ADMIN', 'Quản trị chi', 'Quản lý thông tin & thành viên thuộc chi phái.'),
                _buildRoleOption(index, 'EDITOR', 'Biên soạn', 'Thêm mới, sửa đổi thông tin phả hệ gia tộc.'),
                _buildRoleOption(index, 'VIEWER', 'Thành viên', 'Chỉ xem phả hệ dòng tộc.'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRoleOption(int userIndex, String roleValue, String roleTitle, String roleDesc) {
    final currentRole = _users[userIndex]['role'];
    final isSelected = currentRole == roleValue;

    return ListTile(
      onTap: () {
        setState(() {
          _users[userIndex]['role'] = roleValue;
        });
        Navigator.pop(context);
        AppSnackBar.success(
          context,
          'Đã cập nhật vai trò của ${_users[userIndex]['fullName']} thành $roleTitle!',
        );
      },
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AdminDashboardPage.roleColor(roleValue).withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          roleValue == 'OWNER'
              ? LucideIcons.crown
              : roleValue == 'BRANCH_ADMIN'
                  ? LucideIcons.shield
                  : roleValue == 'EDITOR'
                      ? LucideIcons.edit3
                      : LucideIcons.user,
          color: AdminDashboardPage.roleColor(roleValue),
          size: 18,
        ),
      ),
      title: Text(
        roleTitle,
        style: GoogleFonts.beVietnamPro(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        roleDesc,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: isSelected
          ? const Icon(LucideIcons.check, color: AppColors.crimson, size: 20)
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        backgroundColor: AppColors.wood,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Phân quyền thành viên',
          style: GoogleFonts.beVietnamPro(
            color: AppColors.gold,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: _users.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final user = _users[index];
            final role = user['role'] as String;

            return Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                onTap: () => _showRoleSelector(index),
                leading: CircleAvatar(
                  backgroundColor: AppColors.wood.withValues(alpha: 0.1),
                  child: Text(
                    user['fullName'][0].toUpperCase(),
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.bold,
                      color: AppColors.wood,
                    ),
                  ),
                ),
                title: Text(
                  user['fullName'],
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                subtitle: Text(
                  user['email'],
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AdminDashboardPage.roleColor(role).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    AdminDashboardPage.roleLabel(role),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AdminDashboardPage.roleColor(role),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            );
          },
        ),
      ),
    );
  }
}
