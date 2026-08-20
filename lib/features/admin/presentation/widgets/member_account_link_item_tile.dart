import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:giatocviet/core/theme/app_theme.dart';
import 'package:giatocviet/core/theme/theme_extensions.dart';
import 'package:giatocviet/core/widgets/widgets.dart';
import 'package:giatocviet/features/admin/domain/entities/member_account_link_entity.dart';
import 'package:giatocviet/resources/app_localizations.dart';

/// Chip trạng thái liên kết (Đã liên kết / Chờ mời / Chưa liên kết).
class LinkStatusChip extends StatelessWidget {
  const LinkStatusChip({
    super.key,
    required this.item,
    required this.l10n,
  });

  final MemberAccountLinkEntity item;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final (String label, Color color) = switch (item) {
      _ when item.isLinked => (l10n.linkedLabel, Colors.green),
      _ when item.pendingInvite != null => (l10n.invitePendingLabel, AppColors.accent),
      _ => (l10n.notLinkedLabel, context.textSecondary),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
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
}

/// Thẻ hiển thị một thành viên và thao tác liên kết / huỷ liên kết tài khoản.
class MemberAccountLinkItemTile extends StatelessWidget {
  const MemberAccountLinkItemTile({
    super.key,
    required this.item,
    this.familyId,
    required this.l10n,
    required this.onLinkPressed,
    required this.onUnlinkPressed,
  });

  final MemberAccountLinkEntity item;
  final int? familyId;
  final AppLocalizations l10n;
  final VoidCallback? onLinkPressed;
  final VoidCallback? onUnlinkPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: context.accent.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppAvatar(
                avatarUrl: item.avatarUrl,
                fullName: item.fullName,
                radius: 22,
                backgroundColor: context.primary.withValues(alpha: 0.15),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.fullName,
                      style: GoogleFonts.beVietnamPro(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: context.textPrimary,
                      ),
                    ),
                    if (item.isLinked && item.linkedAccount != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.linkedAccount!.email,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: context.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ] else if (item.pendingInvite != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.pendingInvite!.email,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: context.resolve(
                            AppColors.accent,
                            AppColors.accent,
                          ),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (item.generation != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        l10n.generationLabel('${item.generation}'),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: context.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              LinkStatusChip(item: item, l10n: l10n),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: item.isLinked
                      ? l10n.changeEmailButton
                      : l10n.linkInviteButton,
                  variant: AppButtonVariant.outline,
                  size: AppButtonSize.small,
                  prefixIcon: const Icon(LucideIcons.mail, size: 14),
                  onPressed: familyId == null ? null : onLinkPressed,
                ),
              ),
              if (item.isLinked || item.pendingInvite != null) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: AppButton(
                    label: l10n.unlinkButton,
                    color: context.primary,
                    size: AppButtonSize.small,
                    prefixIcon: const Icon(LucideIcons.unlink, size: 14),
                    onPressed: familyId == null ? null : onUnlinkPressed,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}