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
import '../../../../core/widgets/app_appbar.dart';

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
    final canEdit = authState is Authenticated &&
        (authState.user.role == 'OWNER' ||
            authState.user.role == 'BRANCH_ADMIN' ||
            authState.user.role == 'EDITOR');

    return Scaffold(
      backgroundColor: context.background,
      extendBodyBehindAppBar: true,
      appBar: AppAppBar(
        title: 'Chi tiết thành viên',
        transparent: true,
        actions: canEdit
            ? [
                IconButton(
                  icon: const Icon(LucideIcons.edit3, color: Colors.white),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdminMemberFormPage(
                          memberId: widget.member.id,
                        ),
                      ),
                    );
                    if (result == true && context.mounted) {
                      Navigator.pop(context, true);
                    }
                  },
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header Stack ──
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Clouds background banner
                Container(
                  height: 150 + MediaQuery.of(context).padding.top,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                      image: AssetImage('assets/images/clouds.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    color: context.appBarBg.withValues(alpha: 0.8),
                  ),
                ),
                // Avatar overlapping
                Positioned(
                  bottom: -40,
                  child: Container(
                    width: 90,
                    height: 90,
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
                    child: CircleAvatar(
                      radius: 42,
                      backgroundColor: context.background,
                      backgroundImage: widget.member.avatarUrl != null
                          ? NetworkImage(widget.member.avatarUrl!)
                          : null,
                      child: widget.member.avatarUrl == null
                          ? Icon(
                              LucideIcons.user,
                              size: 45,
                              color: context.primary,
                            )
                          : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),

            // ── Name & Badges ──
            Column(
              children: [
                Text(
                  widget.member.fullName.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: context.primary,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 6),
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
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Detailed Information ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              child: Column(
                children: [
                  _buildInfoSection(l10n.personalInfoSectionTitle, [
                    _buildInfoRow(
                      LucideIcons.cake,
                      l10n.dateOfBirthLabel,
                      DateFormatter.formatForDisplay(
                              widget.member.dateOfBirth) ??
                          '-',
                    ),
                    if (!widget.member.isAlive)
                      _buildInfoRow(
                        LucideIcons.skull,
                        l10n.dateOfDeathLabel,
                        DateFormatter.formatForDisplay(
                                widget.member.dateOfDeath) ??
                            '-',
                      ),
                    _buildInfoRow(
                      widget.member.gender == Gender.male
                          ? LucideIcons.user
                          : LucideIcons.user,
                      l10n.genderLabel,
                      widget.member.gender == Gender.male
                          ? l10n.genderMale
                          : l10n.genderFemale,
                    ),
                    _buildInfoRow(
                      LucideIcons.mapPin,
                      l10n.placeOfBirthLabel,
                      widget.member.placeOfBirth ?? '-',
                    ),
                  ]),
                  const SizedBox(height: 20),
                  Builder(builder: (context) {
                    final parentNode = widget.allMembers
                        .where((m) => m.id == widget.member.parentId)
                        .firstOrNull;
                    final spouseNode =
                        (parentNode != null && parentNode.spouseId != null)
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

                    // If mother is still null, check if we have a direct motherId
                    if (mother == null && widget.member.motherId != null) {
                      mother = widget.allMembers
                          .where((m) => m.id == widget.member.motherId)
                          .firstOrNull;
                    }

                    final spouse = widget.allMembers
                        .where((m) => m.id == widget.member.spouseId)
                        .firstOrNull;

                    return _buildInfoSection(l10n.familyRelationSectionTitle, [
                      _buildInfoRow(
                        LucideIcons.user,
                        'Cha',
                        father?.fullName ?? '-',
                      ),
                      _buildInfoRow(
                        LucideIcons.user,
                        'Mẹ',
                        mother?.fullName ?? '-',
                      ),
                      _buildInfoRow(
                        LucideIcons.heart,
                        'Vợ/Chồng',
                        spouse?.fullName ?? '-',
                      ),
                      _buildInfoRow(
                        LucideIcons.gitCommit,
                        l10n.branchLabel,
                        widget.member.branchName ?? '-',
                      ),
                    ]);
                  }),
                  const SizedBox(height: 20),
                  _buildBiographySection(l10n),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.beVietnamPro(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.accent.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: context.resolve(
                Colors.black.withValues(alpha: 0.01), Colors.transparent),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.beVietnamPro(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: context.primary,
            ),
          ),
          const Divider(height: 24),
          ...children,
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

  Widget _buildBiographySection(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.accent.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.biographySectionTitle,
            style: GoogleFonts.beVietnamPro(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: context.primary,
            ),
          ),
          const Divider(height: 24),
          Text(
            widget.member.notes != null && widget.member.notes!.isNotEmpty
                ? widget.member.notes!
                : l10n.noBiographyMessage,
            style: GoogleFonts.inter(
              fontSize: 14,
              height: 1.6,
              color: context.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
