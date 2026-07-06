import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:giatocviet/core/theme/app_theme.dart';
import 'package:giatocviet/core/widgets/widgets.dart';
import 'package:giatocviet/core/domain/entity/family_user_entity.dart';
import 'package:giatocviet/features/auth/auth.dart';
import 'package:giatocviet/features/admin/presentation/pages/admin_dashboard/admin_dashboard_page.dart';
import 'package:giatocviet/features/admin/presentation/bloc/admin_member_roles/admin_member_roles_bloc.dart';

class AdminMemberRolesPage extends StatefulWidget {
  const AdminMemberRolesPage({super.key});

  @override
  State<AdminMemberRolesPage> createState() => _AdminMemberRolesPageState();
}

class _AdminMemberRolesPageState extends State<AdminMemberRolesPage> {
  bool _isSearching = false;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated && authState.user.familyId != null) {
        context.read<AdminMemberRolesBloc>().add(
              LoadAdminMemberRolesEvent(familyId: authState.user.familyId!),
            );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showRoleSelector(FamilyUserEntity user, int familyId) {
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    'Vai trò của ${user.userFullName ?? 'thành viên'}',
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const Divider(),
                _buildRoleOption(user, familyId, 'BRANCH_ADMIN', 'Trưởng chi',
                    'Quản lý nhân sự và nội dung của chi tộc.'),
                _buildRoleOption(user, familyId, 'EDITOR', 'Biên tập viên',
                    'Đóng góp và chỉnh sửa thông tin gia phả.'),
                _buildRoleOption(user, familyId, 'VIEWER', 'Thành viên',
                    'Chỉ được xem thông tin gia tộc.'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRoleOption(FamilyUserEntity user, int familyId, String roleValue,
      String roleTitle, String roleDesc) {
    final isSelected = user.role == roleValue;

    return ListTile(
      onTap: () {
        Navigator.pop(context);
        context.read<AdminMemberRolesBloc>().add(
              UpdateAdminMemberRoleEvent(
                familyId: familyId,
                userId: user.userId,
                role: roleValue,
              ),
            );
      },
      leading: Icon(
        roleValue == 'OWNER'
            ? LucideIcons.crown
            : roleValue == 'BRANCH_ADMIN'
                ? LucideIcons.shield
                : roleValue == 'EDITOR'
                    ? LucideIcons.edit3
                    : LucideIcons.user,
        color: AppColors.textSecondary,
        size: 22,
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
    final authState = context.watch<AuthBloc>().state;
    final familyId =
        authState is Authenticated ? authState.user.familyId : null;

    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        backgroundColor: AppColors.wood,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: GoogleFonts.beVietnamPro(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Tìm thành viên...',
                  hintStyle:
                      GoogleFonts.beVietnamPro(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (value) => setState(() {}),
              )
            : Text(
                'Phân quyền thành viên',
                style: GoogleFonts.beVietnamPro(
                  color: AppColors.gold,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(
                _isSearching ? LucideIcons.x : LucideIcons.search,
                color: Colors.white),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) _searchController.clear();
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<AdminMemberRolesBloc, AdminMemberRolesState>(
          listener: (context, state) {
            if (state is AdminMemberRoleUpdatedSuccess) {
              AppSnackBar.success(context, 'Cập nhật vai trò thành công!');
              if (familyId != null) {
                context.read<AdminMemberRolesBloc>().add(
                      LoadAdminMemberRolesEvent(familyId: familyId),
                    );
              }
            } else if (state is AdminMemberRolesFailure) {
              AppSnackBar.error(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is AdminMemberRolesLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.wood,
                ),
              );
            }

            if (state is AdminMemberRolesFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    state.message,
                    style: GoogleFonts.beVietnamPro(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            List<FamilyUserEntity> members = [];
            if (state is AdminMemberRolesLoaded) {
              members = state.members;
            } else {
              final blocState = context.read<AdminMemberRolesBloc>().state;
              if (blocState is AdminMemberRolesLoaded) {
                members = blocState.members;
              }
            }

            final allMembers = members;
            final query = _searchController.text.trim().toLowerCase();
            if (query.isNotEmpty) {
              members = members
                  .where((m) =>
                      (m.userFullName ?? '').toLowerCase().contains(query))
                  .toList();
            }

            if (allMembers.isEmpty) {
              return Center(
                child: Text(
                  'Chưa có thành viên nào trong gia tộc.',
                  style: GoogleFonts.beVietnamPro(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              );
            }

            if (members.isEmpty) {
              return Center(
                child: Text(
                  'Không tìm thấy thành viên phù hợp.',
                  style: GoogleFonts.beVietnamPro(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: members.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final user = members[index];
                final role = user.role;

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
                    onTap: familyId == null
                        ? null
                        : () {
                            final currentUserId = authState is Authenticated
                                ? authState.user.id
                                : null;
                            if (user.userId == currentUserId) {
                              AppSnackBar.warning(
                                context,
                                'Bạn không thể tự thay đổi quyền của chính mình. Hãy dùng tính năng "Chuyển nhượng quyền Trưởng tộc".',
                              );
                            } else {
                              _showRoleSelector(user, familyId);
                            }
                          },
                    leading: CircleAvatar(
                      backgroundColor: AppColors.wood.withValues(alpha: 0.1),
                      backgroundImage: user.userAvatarUrl != null
                          ? NetworkImage(user.userAvatarUrl!)
                          : null,
                      child: user.userAvatarUrl == null
                          ? Text(
                              (user.userFullName ?? 'U')[0].toUpperCase(),
                              style: GoogleFonts.beVietnamPro(
                                fontWeight: FontWeight.bold,
                                color: AppColors.wood,
                              ),
                            )
                          : null,
                    ),
                    title: Text(
                      user.userFullName ?? 'Thành viên',
                      style: GoogleFonts.beVietnamPro(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      user.userEmail ?? 'Chưa có email',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AdminDashboardPage.roleColor(role)
                                .withValues(alpha: 0.15),
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
                        const SizedBox(width: 4),
                        const Icon(
                          LucideIcons.chevronRight,
                          color: AppColors.textSecondary,
                          size: 16,
                        ),
                      ],
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
