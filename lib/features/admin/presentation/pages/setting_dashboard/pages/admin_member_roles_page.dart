import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:giatocviet/core/theme/app_theme.dart';
import 'package:giatocviet/core/theme/theme_extensions.dart';
import 'package:giatocviet/core/widgets/widgets.dart';
import 'package:giatocviet/core/domain/entity/family_user_entity.dart';
import 'package:giatocviet/resources/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: context.background,
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
                    l10n.roleOfUser(user.userFullName ?? l10n.roleViewer.toLowerCase()),
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: context.textPrimary,
                    ),
                  ),
                ),
                const Divider(),
                _buildRoleOption(user, familyId, 'BRANCH_ADMIN', l10n.roleBranchAdminTitle,
                    l10n.roleBranchAdminDesc),
                _buildRoleOption(user, familyId, 'EDITOR', l10n.roleEditorTitle,
                    l10n.roleEditorDesc),
                _buildRoleOption(user, familyId, 'VIEWER', l10n.roleViewerTitle,
                    l10n.roleViewerDesc),
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
        color: context.textSecondary,
        size: 22,
      ),
      title: Text(
        roleTitle,
        style: GoogleFonts.beVietnamPro(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: context.textPrimary,
        ),
      ),
      subtitle: Text(
        roleDesc,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: context.textSecondary,
        ),
      ),
      trailing: isSelected
          ? Icon(LucideIcons.check, color: context.primary, size: 20)
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.watch<AuthBloc>().state;
    final familyId =
        authState is Authenticated ? authState.user.familyId : null;

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        backgroundColor: context.appBarBg,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: GoogleFonts.beVietnamPro(color: Colors.white),
                decoration: InputDecoration(
                  hintText: l10n.searchMemberHint,
                  hintStyle:
                      GoogleFonts.beVietnamPro(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (value) => setState(() {}),
              )
            : Text(
                l10n.memberRolesTitle,
                style: GoogleFonts.beVietnamPro(
                  color: context.accent,
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
              AppSnackBar.success(context, l10n.updateRoleSuccess);
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
                child: AppLoading(size: 80),
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
                  l10n.noMembers,
                  style: GoogleFonts.beVietnamPro(
                    color: context.textSecondary,
                    fontSize: 14,
                  ),
                ),
              );
            }

            if (members.isEmpty) {
              return Center(
                child: Text(
                  l10n.noMemberFound,
                  style: GoogleFonts.beVietnamPro(
                    color: context.textSecondary,
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
                    color: context.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: context.accent.withValues(alpha: 0.25),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: context.resolve(Colors.black, Colors.black)
                            .withValues(alpha: 0.03),
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
                                l10n.cannotSelfChange,
                              );
                            } else {
                              _showRoleSelector(user, familyId);
                            }
                          },
                    leading: CircleAvatar(
                      backgroundColor: context.appBarBg.withValues(alpha: 0.1),
                      backgroundImage: user.userAvatarUrl != null
                          ? NetworkImage(user.userAvatarUrl!)
                          : null,
                      child: user.userAvatarUrl == null
                          ? Text(
                              (user.userFullName ?? 'U')[0].toUpperCase(),
                              style: GoogleFonts.beVietnamPro(
                                fontWeight: FontWeight.bold,
                                color: context.appBarBg,
                              ),
                            )
                          : null,
                    ),
                    title: Text(
                      user.userFullName ?? l10n.roleViewer,
                      style: GoogleFonts.beVietnamPro(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: context.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      user.userEmail ?? l10n.noEmail,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: context.textSecondary,
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
                            AdminDashboardPage.roleLabel(role, context),
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AdminDashboardPage.roleColor(role),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          LucideIcons.chevronRight,
                          color: context.textSecondary,
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
