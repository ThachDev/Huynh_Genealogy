import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:giatocviet/features/family_tree/domain/entities/member_entity.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';

class SelectUnlinkedMemberSheet extends StatefulWidget {

  const SelectUnlinkedMemberSheet({
    super.key,
    required this.candidateMembers,
    required this.title,
    this.subtitle,
  });
  final List<MemberEntity> candidateMembers;
  final String title;
  final String? subtitle;

  static Future<MemberEntity?> show(
    BuildContext context, {
    required List<MemberEntity> candidateMembers,
    required String title,
    String? subtitle,
  }) {
    return showModalBottomSheet<MemberEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SelectUnlinkedMemberSheet(
        candidateMembers: candidateMembers,
        title: title,
        subtitle: subtitle,
      ),
    );
  }

  @override
  State<SelectUnlinkedMemberSheet> createState() =>
      _SelectUnlinkedMemberSheetState();
}

class _SelectUnlinkedMemberSheetState extends State<SelectUnlinkedMemberSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cardBg = context.surface;
    final textPrimary = context.textPrimary;
    final textSecondary = context.textSecondary;
    final primaryColor = context.primary;

    final filteredMembers = widget.candidateMembers.where((m) {
      if (_searchQuery.trim().isEmpty) return true;
      final query = _searchQuery.trim().toLowerCase();
      final nameMatches = m.fullName.toLowerCase().contains(query);
      final genMatches = m.generation != null &&
          l10n.generationLabel('${m.generation!}').contains(query);
      return nameMatches || genMatches;
    }).toList();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.78,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: AppBackgroundBody(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 14),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                            letterSpacing: 0.2,
                          ),
                        ),
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: 3),
                          Text(
                            widget.subtitle!,
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child:
                            Icon(LucideIcons.x, size: 18, color: textSecondary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Search Box (styled like AdminMemberRolesPage)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: AppSearchBar(
                controller: _searchController,
                hintText: l10n.searchMemberByNameHint,
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
            ),
            const SizedBox(height: 12),

            // List of unlinked members (styled like AdminMemberRolesPage)
            Expanded(
              child: filteredMembers.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          _searchQuery.isNotEmpty
                              ? l10n.emptyMembers
                              : l10n.noUnlinkedMembers,
                          style: GoogleFonts.beVietnamPro(
                            color: textSecondary,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      itemCount: filteredMembers.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final member = filteredMembers[index];

                        return Container(
                          decoration: const BoxDecoration(),
                          child: ListTile(
                            onTap: () => Navigator.pop(context, member),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: AppAvatar(
                              avatarUrl: member.avatarUrl,
                              fullName: member.fullName,
                            ),
                            title: Text(
                              member.fullName,
                              style: GoogleFonts.beVietnamPro(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: textPrimary,
                              ),
                            ),
                            subtitle: (member.dateOfBirth != null &&
                                    member.dateOfBirth!.isNotEmpty)
                                ? Text(
                                    l10n.birthDateFormat(member.dateOfBirth!),
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: textSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : null,
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                l10n.selectLabel,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
