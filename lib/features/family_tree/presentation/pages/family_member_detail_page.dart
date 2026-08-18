import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/date_formatter.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import '../../../../features/auth/auth.dart';
import '../../../admin/presentation/pages/admin_dashboard/pages/admin_member_form_page.dart';
import '../../../admin/presentation/pages/admin_dashboard/pages/admin_link_and_roles_page.dart';
import '../../../../core/widgets/widgets.dart';

class FamilyMemberDetailPage extends StatefulWidget {
  final MemberEntity member;
  final List<MemberEntity> allMembers;

  const FamilyMemberDetailPage({
    super.key,
    required this.member,
    this.allMembers = const [],
  });

  @override
  State<FamilyMemberDetailPage> createState() => _FamilyMemberDetailPageState();
}

class _FamilyMemberDetailPageState extends State<FamilyMemberDetailPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.watch<AuthBloc>().state;
    final isAdminMode = UserMainNavigationPage.adminModeNotifier.value;
    final canEdit = isAdminMode &&
        authState is Authenticated &&
        (authState.user.role == 'OWNER' ||
            authState.user.role == 'EDITOR' ||
            authState.user.role == 'CREATOR');

    // Lấy thông tin gia đình
    final parentNode = widget.allMembers
        .where((m) => m.id == widget.member.parentId)
        .firstOrNull;
    final spouseNode = (parentNode != null && parentNode.spouseId != null)
        ? widget.allMembers
            .where((m) => m.id == parentNode.spouseId)
            .firstOrNull
        : null;

    MemberEntity? father;
    MemberEntity? mother;

    if (parentNode != null) {
      if (parentNode.gender == Gender.female) {
        mother = parentNode;
        father = spouseNode;
      } else {
        father = parentNode;
        mother = spouseNode;
      }
    }

    if (mother == null && widget.member.motherId != null) {
      mother = widget.allMembers
          .where((m) => m.id == widget.member.motherId)
          .firstOrNull;
    }

    final spouse = widget.allMembers
        .where((m) => m.id == widget.member.spouseId)
        .firstOrNull;

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppAppBar(
        title: l10n.memberDetailTitle,
        transparent: false,
        actions: [
          if (canEdit) ...[
            IconButton(
              icon: Icon(LucideIcons.link2, color: context.textPrimary),
              tooltip: l10n.linkAccountsLabel,
              onPressed: () {
                Navigator.push(
                  context,
                  SereneFadeSlidePageRoute(
                    page: AdminLinkAndRolesPage(
                      memberId: widget.member.id,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(LucideIcons.edit3, color: context.textPrimary),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  SereneFadeSlidePageRoute(
                    page: AdminMemberFormPage(
                      memberId: widget.member.id,
                    ),
                  ),
                );
                if (result == true && context.mounted) {
                  Navigator.pop(context, true);
                }
              },
            ),
          ],
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
                padding: const EdgeInsets.only(
                    top: 48), // Chừa chỗ cho avatar nổi lên
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 64, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Họ và tên
                      Center(
                        child: Column(
                          children: [
                            Text(
                              widget.member.fullName.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: context.primary,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildBadge(
                                  l10n.generationBadge(
                                      '${widget.member.generation ?? "?"}'),
                                  context.accent,
                                ),
                                const SizedBox(width: 8),
                                _buildBadge(
                                  widget.member.isAlive
                                      ? l10n.aliveLabel
                                      : l10n.deceasedLabel,
                                  widget.member.isAlive
                                      ? Colors.green
                                      : context.textSecondary,
                                  icon: widget.member.isAlive
                                      ? null
                                      : LucideIcons.flame,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Divider(height: 1),
                      const SizedBox(height: 16),

                      // Section 1: Thông tin cá nhân
                      _buildSectionHeader(l10n.personalInfoSectionTitle),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        LucideIcons.cake,
                        l10n.dateOfBirthLabel,
                        DateFormatter.formatForDisplay(
                                widget.member.dateOfBirth) ??
                            'Không rõ',
                      ),
                      if (!widget.member.isAlive)
                        _buildInfoRow(
                          LucideIcons.skull,
                          l10n.dateOfDeathLabel,
                          DateFormatter.formatForDisplay(
                                  widget.member.dateOfDeath) ??
                              'Không rõ',
                        ),
                      _buildInfoRow(
                        LucideIcons.user,
                        l10n.genderLabel,
                        widget.member.gender == Gender.male
                            ? l10n.genderMale
                            : l10n.genderFemale,
                      ),
                      _buildInfoRow(
                        LucideIcons.mapPin,
                        l10n.placeOfBirthLabel,
                        (widget.member.placeOfBirth?.isNotEmpty == true)
                            ? widget.member.placeOfBirth!
                            : 'Không rõ',
                      ),
                      _buildInfoRow(
                        LucideIcons.bookOpen,
                        l10n.educationLabel,
                        (widget.member.education?.isNotEmpty == true)
                            ? widget.member.education!
                            : 'Không rõ',
                      ),
                      _buildInfoRow(
                        LucideIcons.briefcase,
                        l10n.occupationLabel,
                        (widget.member.occupation?.isNotEmpty == true)
                            ? widget.member.occupation!
                            : 'Không rõ',
                      ),
                      const SizedBox(height: 24),
                      const Divider(height: 1),
                      const SizedBox(height: 16),

                      // Section 2: Quan hệ gia đình
                      _buildSectionHeader(l10n.familyRelationSectionTitle),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        LucideIcons.user,
                        l10n.fatherLabel,
                        father?.fullName ?? 'Không rõ',
                      ),
                      _buildInfoRow(
                        LucideIcons.user,
                        l10n.motherLabel,
                        mother?.fullName ?? 'Không rõ',
                      ),
                      _buildInfoRow(
                        LucideIcons.heart,
                        l10n.spouseLabel,
                        spouse?.fullName ?? 'Không rõ',
                      ),
                      _buildInfoRow(
                        LucideIcons.gitCommit,
                        l10n.branchLabel,
                        (widget.member.branchName?.isNotEmpty == true)
                            ? widget.member.branchName!
                            : 'Không rõ',
                      ),
                      const SizedBox(height: 24),
                      const Divider(height: 1),
                      const SizedBox(height: 16),

                      // Section 3: Tiểu sử
                      _buildSectionHeader(l10n.biographySectionTitle),
                      const SizedBox(height: 12),
                      Text(
                        widget.member.notes != null &&
                                widget.member.notes!.isNotEmpty
                            ? widget.member.notes!
                            : l10n.noBiographyMessage,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Avatar nổi ở mép trên ──
              Positioned(
                top: 0,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: context.accent, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: context.resolve(
                            Colors.black.withValues(alpha: 0.15),
                            Colors.transparent),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: AppAvatar(
                    avatarUrl: widget.member.avatarUrl,
                    fullName: widget.member.fullName,
                    radius: 45,
                    fontSize: 32,
                    backgroundColor: context.background,
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
    return Text(
      title,
      style: GoogleFonts.beVietnamPro(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: context.primary,
      ),
    );
  }

  Widget _buildBadge(String label, Color color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: GoogleFonts.beVietnamPro(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: context.accent),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: context.textSecondary,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
