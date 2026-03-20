import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/components/theme/app_theme.dart';
import 'package:app_family_tree/features/member/domain/entities/member.dart';
import 'package:resources/resources.dart';

class MemberSearchOverlay extends StatelessWidget {
  final String searchQuery;
  final List<MemberEntity> allMembers;
  final Function(MemberEntity) onMemberTap;
  final VoidCallback onClose;

  const MemberSearchOverlay({
    super.key,
    required this.searchQuery,
    required this.allMembers,
    required this.onMemberTap,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    if (searchQuery.isEmpty) return const SizedBox.shrink();

    final l10n = S.of(context);
    final filteredMembers = allMembers.where((m) {
      return m.fullName.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    if (filteredMembers.isEmpty) return const SizedBox.shrink();

    return Positioned(
      top: 10,
      left: 16,
      right: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: Container(
          constraints: const BoxConstraints(maxHeight: 250),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: filteredMembers.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final m = filteredMembers[index];
                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        radius: 14,
                        backgroundColor: m.gender == Gender.male
                            ? AppColors.nodeMale
                            : AppColors.nodeFemale,
                        child: Icon(
                          m.gender == Gender.male ? Icons.man : Icons.woman,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        m.fullName,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${l10n.generation} ${m.generation ?? "?"}',
                        style: GoogleFonts.inter(fontSize: 11),
                      ),
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onMemberTap(m);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
