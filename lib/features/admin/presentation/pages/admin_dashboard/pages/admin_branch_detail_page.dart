import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../resources/app_localizations.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/domain/entity/branch_entity.dart';
import '../../../../../../core/domain/entity/member_entity.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../auth/auth.dart';
import 'admin_branch_form_page.dart';

class AdminBranchDetailPage extends StatelessWidget {

  const AdminBranchDetailPage({
    super.key,
    required this.branch,
    this.members = const [],
  });
  final BranchEntity branch;
  final List<MemberEntity> members;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = context.watch<AuthBloc>().state;
    final isAdminMode = UserMainNavigationPage.adminModeNotifier.value;
    final canEdit = isAdminMode &&
        authState is Authenticated &&
        (authState.user.role == 'OWNER' ||
            authState.user.role == 'EDITOR' ||
            authState.user.role == 'CREATOR');

    final branchMembers =
        members.where((m) => m.branchId == branch.id).toList();

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppAppBar(
        title: l10n.branchLabel,
        actions: [
          if (canEdit)
            IconButton(
              icon: Icon(LucideIcons.edit3, color: context.textPrimary),
              tooltip: l10n.editBranchTitle,
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  SereneFadeSlidePageRoute(
                    page: AdminBranchFormPage(branch: branch),
                  ),
                );
                if (result == true && context.mounted) {
                  Navigator.pop(context, true);
                }
              },
            ),
        ],
      ),
      body: AppBackgroundBody(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // ── Khối thông tin gộp chung ──
              Padding(
                padding:
                    const EdgeInsets.only(top: 48), // Chừa chỗ cho icon nổi lên
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 64, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tên Chi Tộc
                      Center(
                        child: Column(
                          children: [
                            Text(
                              branch.name.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: context.primary,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildBadge(
                              '${branchMembers.length} ${l10n.statMembers}',
                              context.accent,
                              icon: LucideIcons.users,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Divider(height: 1),
                      const SizedBox(height: 16),

                      // Section 1: Thông tin cơ bản
                      _buildSectionHeader(l10n.personalInfoSectionTitle),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        LucideIcons.userCheck,
                        l10n.founderLabel,
                        (branch.founderName?.isNotEmpty == true)
                            ? branch.founderName!
                            : l10n.unknownLabel,
                      ),
                      _buildInfoRow(
                        LucideIcons.calendar,
                        l10n.establishedYearLabel,
                        branch.foundingYear != null
                            ? '${branch.foundingYear}'
                            : l10n.unknownLabel,
                      ),
                      _buildInfoRow(
                        LucideIcons.mapPin,
                        l10n.regionLabel,
                        (branch.region?.isNotEmpty == true)
                            ? branch.region!
                            : l10n.unknownLabel,
                      ),
                      _buildInfoRow(
                        LucideIcons.users,
                        l10n.memberCountLabel,
                        l10n.memberCountBadge(branchMembers.length),
                      ),
                      const SizedBox(height: 24),
                      const Divider(height: 1),
                      const SizedBox(height: 16),

                      // Section 2: Mô tả / Lịch sử chi tộc
                      _buildSectionHeader(l10n.biographySectionTitle),
                      const SizedBox(height: 12),
                      Text(
                        branch.description != null &&
                                branch.description!.isNotEmpty
                            ? branch.description!
                            : l10n.unknownLabel,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: context.textPrimary,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Icon Chi Tộc nổi ở mép trên ──
              Positioned(
                top: 0,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: context.background,
                    shape: BoxShape.circle,
                    border: Border.all(color: context.accent, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: context.resolve(
                          Colors.black.withValues(alpha: 0.15),
                          Colors.transparent,
                        ),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: CircleAvatar(
                      radius: 42,
                      backgroundColor: context.background,
                      child: Icon(
                        LucideIcons.gitBranch,
                        size: 40,
                        color: context.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Builder(
      builder: (context) => Text(
        title,
        style: GoogleFonts.beVietnamPro(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: context.primary,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 16,
              color: context.resolve(
                const Color(0xFFB8860B),
                const Color(0xFFD4AF37),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 4,
              child: Text(
                label,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 13,
                  color: context.textSecondary,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color, {IconData? icon}) {
    return Builder(
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 4),
            ],
            Text(
              text,
              style: GoogleFonts.beVietnamPro(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
