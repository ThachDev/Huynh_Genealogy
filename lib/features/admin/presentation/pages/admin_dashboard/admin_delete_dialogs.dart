import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../resources/app_localizations.dart';
import '../../../../family_tree/family_tree.dart';
import '../../bloc/admin_member_form/admin_member_form_bloc.dart';
import '../../bloc/admin_branch_form/admin_branch_form_bloc.dart';

/// Xác nhận xoá thành viên. Nếu thành viên có con cháu thì hiện 2 lựa chọn:
/// đôn con lên thay thế hoặc xoá và tách nhánh.
Future<void> showMemberDeleteConfirmation(
  BuildContext context,
  MemberEntity member,
) async {
  final l10n = AppLocalizations.of(context);
  final treeState = context.read<FamilyTreeBloc>().state;
  final allMembers =
      treeState is FamilyTreeLoaded ? treeState.members : <MemberEntity>[];
  final hasChildren = allMembers.any((m) => m.parentId == member.id);

  if (!hasChildren) {
    final confirmed = await AppDialog.confirm(
      context,
      title: l10n.deleteMemberTitle,
      message: l10n.deleteMemberMessage(member.fullName),
      confirmLabel: l10n.deleteLabel,
      type: AppDialogType.danger,
      showIcon: false,
      confirmColor: context.primary,
      messageSpan: TextSpan(
        style: GoogleFonts.inter(
          fontSize: 13,
          color: context.textPrimary,
          height: 1.5,
        ),
        children: [
          TextSpan(text: l10n.deleteMemberConfirmStart),
          TextSpan(
            text: member.fullName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: l10n.deleteMemberConfirmEnd),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context
          .read<AdminMemberFormBloc>()
          .add(DeleteAdminMemberFormEvent(member.id));
    }
    return;
  }

  showDialog(
    context: context,
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: ctx.surface,
            borderRadius: BorderRadius.circular(20),
            border:
                Border.all(color: ctx.textSecondary.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Header Title (Seamless: Xoá thành viên + member.fullName)
              Text.rich(
                TextSpan(
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 17,
                    color: ctx.textPrimary,
                  ),
                  children: [
                    TextSpan(
                      text: l10n.deleteMemberTitlePrefix,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: member.fullName,
                      style: GoogleFonts.beVietnamPro(
                        fontWeight: FontWeight.bold,
                        color: ctx.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.deleteMemberWithDescendantsMessage,
                style: GoogleFonts.inter(
                    fontSize: 13, color: ctx.textPrimary, height: 1.4),
              ),
              const SizedBox(height: 16),

              // Option 1: Đôn con lên (Recommended Option Card)
              InkWell(
                onTap: () {
                  Navigator.pop(ctx);
                  context.read<AdminMemberFormBloc>().add(
                      DeleteAdminMemberFormEvent(member.id,
                          reassignChildrenToParent: true));
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: ctx.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ctx.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(LucideIcons.gitMerge,
                            color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  l10n.promoteChildrenOption,
                                  style: GoogleFonts.beVietnamPro(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: ctx.textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: ctx.primary.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    l10n.recommendedLabel,
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: ctx.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.promoteChildrenDesc,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: ctx.textSecondary,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Option 2: Xoá & Tách nhánh (Danger / Secondary Action)
              InkWell(
                onTap: () {
                  Navigator.pop(ctx);
                  context.read<AdminMemberFormBloc>().add(
                      DeleteAdminMemberFormEvent(member.id));
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: ctx.error.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ctx.error.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(LucideIcons.gitBranch,
                            color: ctx.error, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.deleteAndDetachOption,
                              style: GoogleFonts.beVietnamPro(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: ctx.error,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.deleteAndDetachDesc,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: ctx.textSecondary,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Cancel Button (Default Text / Ghost Variant)
              AppButton(
                label: l10n.cancelLabel,
                onPressed: () => Navigator.pop(ctx),
                variant: AppButtonVariant.ghost,
                fullWidth: true,
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Xác nhận xoá một chi/nhánh.
void showDeleteBranchConfirmation(BuildContext context, BranchEntity branch) {
  showDialog(
    context: context,
    builder: (ctx) {
      final l10n = AppLocalizations.of(ctx);
      return AlertDialog(
        backgroundColor: ctx.surface,
        title: Text(
          l10n.deleteBranchTitle,
          style: GoogleFonts.beVietnamPro(
              fontWeight: FontWeight.bold, color: ctx.textPrimary),
        ),
        content: Text(
          l10n.deleteBranchMessage(branch.name),
          style: GoogleFonts.beVietnamPro(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancelLabel,
                style: GoogleFonts.beVietnamPro(color: ctx.textSecondary)),
          ),
          AppButton(
            label: l10n.deleteLabel,
            onPressed: () {
              Navigator.pop(ctx);
              context
                  .read<AdminBranchFormBloc>()
                  .add(DeleteAdminBranchFormEvent(branch.id));
            },
            variant: AppButtonVariant.danger,
            size: AppButtonSize.small,
          ),
        ],
      );
    },
  );
}