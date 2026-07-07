import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/date_formatter.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';

class UserMemberDetailPage extends StatefulWidget {
  final MemberEntity member;

  const UserMemberDetailPage({super.key, required this.member});

  @override
  State<UserMemberDetailPage> createState() => _UserMemberDetailPageState();
}

class _UserMemberDetailPageState extends State<UserMemberDetailPage> {
  int _spiritualCount = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.background,
      body: CustomScrollView(
        slivers: [
          // ── Header Modal with Ancient Clouds ──
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            elevation: 4,
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: context.appBarBg,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/clouds.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: context.primary),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              context.resolve(Colors.black.withValues(alpha: 0.5), Colors.transparent),
                              Colors.transparent,
                              context.resolve(Colors.black.withValues(alpha: 0.3), Colors.transparent),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Avatar Overlay and Basic Info ──
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -50),
              child: Column(
                children: [
                  // Large Avatar
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: context.accent, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: context.resolve(Colors.black.withValues(alpha: 0.2), Colors.transparent),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 56,
                      backgroundColor: context.background,
                      backgroundImage: widget.member.avatarUrl != null
                          ? NetworkImage(widget.member.avatarUrl!)
                          : null,
                      child: widget.member.avatarUrl == null
                          ? Icon(
                              LucideIcons.user,
                              size: 60,
                              color: context.primary,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Name
                  Text(
                    widget.member.fullName.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: context.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Badges
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildBadge(
                        l10n.generationBadge('${widget.member.generation ?? "?"}'),
                        context.accent,
                      ),
                      const SizedBox(width: 8),
                      _buildBadge(
                        widget.member.isAlive ? l10n.aliveLabel : l10n.deceasedLabel,
                        widget.member.isAlive
                            ? Colors.green
                            : context.textSecondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Spiritual Interaction
                  _buildSpiritualButton(),
                ],
              ),
            ),
          ),

          // ── Detailed Information ──
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildInfoSection(l10n.personalInfoSectionTitle, [
                  _buildInfoRow(
                    LucideIcons.cake,
                    l10n.dateOfBirthLabel,
                    DateFormatter.formatForDisplay(widget.member.dateOfBirth) ??
                        l10n.unknownLabel,
                  ),
                  if (!widget.member.isAlive)
                    _buildInfoRow(
                      LucideIcons.calendar,
                      l10n.dateOfDeathLabel,
                      DateFormatter.formatForDisplay(
                            widget.member.dateOfDeath,
                          ) ??
                          l10n.unknownLabel,
                    ),
                  _buildInfoRow(
                    LucideIcons.mapPin,
                    l10n.placeOfBirthLabel,
                    widget.member.placeOfBirth ?? l10n.unknownLabel,
                  ),
                  _buildInfoRow(
                    LucideIcons.gitBranch,
                    l10n.branchLabel,
                    widget.member.branchName ?? '',
                  ),
                ]),
                const SizedBox(height: 24),
                _buildInfoSection(l10n.familyRelationSectionTitle, [
                  _buildRelationshipRow(l10n.parentLabel, widget.member.parentId),
                  _buildRelationshipRow(l10n.spouseLabel, widget.member.spouseId),
                ]),
                const SizedBox(height: 24),
                _buildBioSection(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildSpiritualButton() {
    final l10n = AppLocalizations.of(context)!;
    final bool isDeceased = !widget.member.isAlive;
    return ElevatedButton.icon(
      onPressed: () {
        setState(() => _spiritualCount++);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isDeceased
                  ? l10n.incenseActionMessage
                  : l10n.congratulateActionMessage,
            ),
            duration: const Duration(seconds: 1),
            backgroundColor: context.primary,
          ),
        );
      },
      icon: Icon(
        isDeceased ? LucideIcons.flame : LucideIcons.gift,
      ),
      label: Text(
        isDeceased
            ? l10n.incenseButton(_spiritualCount)
                : l10n.congratulateButton(_spiritualCount),
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: context.surface,
        foregroundColor: context.primary,
        side: BorderSide(color: context.accent, width: 2),
        elevation: 8,
        shadowColor: context.accent.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(LucideIcons.info, color: context.accent, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        Divider(color: context.accent, thickness: 0.5),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: context.textSecondary.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: context.textSecondary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: context.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelationshipRow(String label, int? memberId) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(LucideIcons.users, size: 18, color: context.accent),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: context.textSecondary,
            ),
          ),
          const Spacer(),
          if (memberId == null)
            Text(
              l10n.unknownLabel,
              style: GoogleFonts.inter(fontStyle: FontStyle.italic),
            )
          else
            TextButton(
              onPressed: () {},
              child: Text(
                l10n.memberIdFormat(memberId),
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: context.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBioSection() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(LucideIcons.scroll, color: context.accent, size: 18),
            const SizedBox(width: 8),
            Text(
              l10n.biographySectionTitle,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        Divider(color: context.accent, thickness: 0.5),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: context.surface,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: context.accent.withValues(alpha: 0.3)),
          ),
          child: Text(
            widget.member.notes ?? l10n.noBiographyMessage,
            style: GoogleFonts.beVietnamPro(
              fontSize: 16,
              height: 1.6,
              fontStyle: FontStyle.italic,
              color: context.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
