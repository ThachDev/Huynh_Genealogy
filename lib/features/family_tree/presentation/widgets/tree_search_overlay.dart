import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../resources/app_localizations.dart';
import '../../domain/entities/member_entity.dart';
import 'tree_edge_painter.dart';

/// Thanh nhập tìm kiếm trên AppBar
class TreeSearchBarWidget extends StatelessWidget {
  const TreeSearchBarWidget({
    super.key,
    required this.isSearching,
    required this.searchController,
    required this.searchFocusNode,
    required this.searchQuery,
    required this.appBarTitle,
  });

  final bool isSearching;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final String searchQuery;
  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axis: Axis.horizontal,
            child: child,
          ),
        );
      },
      child: isSearching
          ? Container(
              key: const ValueKey('search_input_active'),
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: context.resolve(
                  Colors.white.withValues(alpha: 0.95),
                  context.surface.withValues(alpha: 0.95),
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: context.accent.withValues(alpha: 0.12),
                ),
              ),
              child: TextField(
                controller: searchController,
                focusNode: searchFocusNode,
                textAlignVertical: TextAlignVertical.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: context.textPrimary,
                  height: 1.2,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: l10n.searchMemberHint,
                  hintStyle: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: context.textSecondary.withValues(alpha: 0.6),
                    height: 1.2,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: Icon(
                      LucideIcons.search,
                      size: 16,
                      color: context.textSecondary,
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  suffixIcon: searchQuery.isNotEmpty
                      ? GestureDetector(
                          onTap: searchController.clear,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12, left: 4),
                            child: Icon(
                              LucideIcons.x,
                              size: 16,
                              color: context.textSecondary,
                            ),
                          ),
                        )
                      : null,
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            )
          : Text(
              appBarTitle,
              key: const ValueKey('search_title_inactive'),
              style: GoogleFonts.beVietnamPro(
                color: context.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
    );
  }
}

/// Menu Dropdown gợi ý kết quả tìm kiếm thành viên
class TreeSearchDropdownOverlay extends StatelessWidget {
  const TreeSearchDropdownOverlay({
    super.key,
    required this.isSearching,
    required this.searchQuery,
    required this.members,
    required this.onSelectMember,
  });

  final bool isSearching;
  final String searchQuery;
  final List<MemberEntity> members;
  final ValueChanged<MemberEntity> onSelectMember;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filteredMembers = members.where((m) {
      if (searchQuery.isEmpty) return true;
      final q = searchQuery.toLowerCase();
      final name = m.fullName.toLowerCase();
      final phone = (m.phone ?? '').toLowerCase();
      return name.contains(q) || phone.contains(q);
    }).toList();

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      top: isSearching ? 8 : -45,
      left: 16,
      right: 16,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        opacity: isSearching ? 1.0 : 0.0,
        child: IgnorePointer(
          ignoring: !isSearching,
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(16),
            color: context.surface,
            shadowColor: Colors.black.withValues(alpha: 0.3),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 340),
              decoration: BoxDecoration(
                color: context.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: context.accent.withValues(alpha: 0.12),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (filteredMembers.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.searchX,
                            size: 18,
                            color: context.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.emptyMembers,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: context.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        itemCount: filteredMembers.length > 8
                            ? 8
                            : filteredMembers.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: context.textSecondary.withValues(alpha: 0.1),
                        ),
                        itemBuilder: (context, index) {
                          final m = filteredMembers[index];
                          final genText = m.generation != null
                              ? l10n.generationLevelFormat(
                                  TreeEdgePainter.toRoman(m.generation!))
                              : '';

                          return ListTile(
                            dense: true,
                            leading: AppAvatar(
                              avatarUrl: m.avatarUrl,
                              fullName: m.fullName,
                              radius: 18,
                            ),
                            title: Text(
                              m.fullName,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: context.textPrimary,
                              ),
                            ),
                            subtitle: Text(
                              [
                                if (genText.isNotEmpty) genText,
                                if (!m.isAlive) l10n.deceasedLabel
                              ].join(' • '),
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: context.textSecondary,
                              ),
                            ),
                            trailing: Icon(
                              LucideIcons.focus,
                              size: 16,
                              color: context.textSecondary,
                            ),
                            onTap: () => onSelectMember(m),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
