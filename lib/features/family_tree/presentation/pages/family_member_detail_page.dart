import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/date_formatter.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import '../../../../core/widgets/widgets.dart';

class FamilyMemberDetailPage extends StatefulWidget {
  final MemberEntity member;

  const FamilyMemberDetailPage({super.key, required this.member});

  @override
  State<FamilyMemberDetailPage> createState() => _FamilyMemberDetailPageState();
}

class _FamilyMemberDetailPageState extends State<FamilyMemberDetailPage> {
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
                            context.resolve(Colors.black.withValues(alpha: 0.5),
                                Colors.transparent),
                            Colors.transparent,
                            context.resolve(Colors.black.withValues(alpha: 0.3),
                                Colors.transparent),
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
                          color: context.resolve(
                              Colors.black.withValues(alpha: 0.2),
                              Colors.transparent),
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
                    DateFormatter.formatForDisplay(widget.member.dateOfBirth) ?? '-',
                  ),
                  if (!widget.member.isAlive)
                    _buildInfoRow(
                      LucideIcons.skull,
                      l10n.dateOfDeathLabel,
                      DateFormatter.formatForDisplay(widget.member.dateOfDeath) ?? '-',
                    ),
                  _buildInfoRow(
                    widget.member.gender == Gender.male ? LucideIcons.user : LucideIcons.user,
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
                _buildInfoSection(l10n.familyRelationSectionTitle, [
                  _buildInfoRow(
                    LucideIcons.network,
                    l10n.parentLabel,
                    widget.member.parentId != null ? '#${widget.member.parentId}' : '-',
                  ),
                  _buildInfoRow(
                    LucideIcons.heart,
                    l10n.spouseLabel,
                    widget.member.spouseId != null ? '#${widget.member.spouseId}' : '-',
                  ),
                  _buildInfoRow(
                    LucideIcons.gitCommit,
                    l10n.branchLabel,
                    widget.member.branchName ?? '-',
                  ),
                ]),
                const SizedBox(height: 20),
                _buildBiographySection(l10n),
              ]),
            ),
          ),
        ],
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

  Widget _buildSpiritualButton() {
    final l10n = AppLocalizations.of(context)!;
    if (widget.member.isAlive) {
      return AppButton(
        label: l10n.congratulateButton(0),
        onPressed: () {
          AppSnackBar.success(context, l10n.congratulateActionMessage);
        },
        prefixIcon: const Icon(LucideIcons.partyPopper, size: 16),
        variant: AppButtonVariant.primary,
        size: AppButtonSize.small,
      );
    }

    return Column(
      children: [
        AppButton(
          label: l10n.incenseButton(0),
          onPressed: () {
            setState(() {
              _spiritualCount++;
            });
            AppSnackBar.success(context, l10n.incenseActionMessage);
          },
          prefixIcon: const Icon(LucideIcons.flame, size: 16),
          variant: AppButtonVariant.primary,
          size: AppButtonSize.small,
        ),
        if (_spiritualCount > 0) ...[
          const SizedBox(height: 8),
          Text(
            l10n.incenseButton(_spiritualCount),
            style: GoogleFonts.beVietnamPro(
              fontSize: 12,
              color: context.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
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
