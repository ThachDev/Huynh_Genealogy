import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:giatocviet/core/theme/theme_extensions.dart';
import 'package:giatocviet/core/domain/entity/family_user_entity.dart';
import 'package:giatocviet/resources/app_localizations.dart';

/// Một lựa chọn vai trò (EDITOR / VIEWER) trong sheet phân quyền.
class RoleOptionTile extends StatelessWidget {
  const RoleOptionTile({
    super.key,
    required this.user,
    required this.familyId,
    required this.roleValue,
    required this.roleTitle,
    required this.roleDesc,
    required this.onSelect,
  });

  final FamilyUserEntity user;
  final int familyId;
  final String roleValue;
  final String roleTitle;
  final String roleDesc;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final isSelected = user.role == roleValue;

    return ListTile(
      onTap: onSelect,
      leading: Icon(
        roleValue == 'EDITOR' ? LucideIcons.edit3 : LucideIcons.user,
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
}

/// Lựa chọn chuyển nhượng quyền Trưởng tộc trong sheet phân quyền.
class TransferOwnershipOptionTile extends StatelessWidget {
  const TransferOwnershipOptionTile({
    super.key,
    required this.user,
    required this.familyId,
    required this.l10n,
    required this.onTransfer,
  });

  final FamilyUserEntity user;
  final int familyId;
  final AppLocalizations l10n;
  final VoidCallback onTransfer;

  @override
  Widget build(BuildContext context) {
    final isOwner = user.role.toUpperCase() == 'OWNER' ||
        user.role.toUpperCase() == 'CREATOR';

    return ListTile(
      onTap: isOwner ? null : onTransfer,
      leading: Icon(
        LucideIcons.crown,
        color: isOwner ? context.textSecondary : context.primary,
        size: 22,
      ),
      title: Row(
        children: [
          Text(
            l10n.transferOwnershipLabel,
            style: GoogleFonts.beVietnamPro(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isOwner ? context.textSecondary : context.primary,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: context.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              l10n.supremeRoleLabel,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: context.primary,
              ),
            ),
          ),
        ],
      ),
      subtitle: Text(
        l10n.transferFullOwnershipLabel,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: context.textSecondary,
        ),
      ),
      trailing: isOwner
          ? Icon(LucideIcons.check, color: context.primary, size: 20)
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}