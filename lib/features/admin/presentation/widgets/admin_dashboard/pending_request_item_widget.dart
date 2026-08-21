import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/domain/entity/family_user_entity.dart';
import '../../bloc/admin_pending_requests/admin_pending_requests_bloc.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../resources/app_localizations.dart';
import '../../../../../core/routes/app_router.dart';
import '../../pages/admin_dashboard/pages/admin_member_form_page.dart';

class PendingRequestItemWidget extends StatelessWidget {

  const PendingRequestItemWidget({
    super.key,
    required this.request,
  });
  final FamilyUserEntity request;

  void _showDetailBottomSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<AdminPendingRequestsBloc>(),
        child: _PendingRequestDetailSheet(request: request, l10n: l10n),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () => _showDetailBottomSheet(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: CustomPaint(
          painter: TraditionalOrnamentalBorderPainter(
            borderColor: context.accent.withValues(alpha: 0.12),
            fillColor: context.surface,
            leftAccentColor: context.accent,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
            child: Row(
              children: [
                // ── Avatar ──
                AppAvatar(
                  avatarUrl: request.userAvatarUrl,
                  fullName: request.userFullName,
                  radius: 26,
                  fontSize: 18,
                ),
                const SizedBox(width: 14),

                // ── Thông tin ──
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        request.userFullName ?? l10n.anonymousUser,
                        style: GoogleFonts.beVietnamPro(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: context.textPrimary,
                          letterSpacing: -0.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.mail,
                            size: 10,
                            color: context.textSecondary.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              request.userEmail ?? l10n.noEmail,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 11,
                                color: context.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Actions ──
                const SizedBox(width: 8),
                IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppButton(
                        label: l10n.approveButton,
                        onPressed: () {
                          context.read<AdminPendingRequestsBloc>().add(
                                ApproveAdminRequestEvent(requestId: request.id),
                              );
                        },
                        size: AppButtonSize.small,
                        fullWidth: true,
                      ),
                      const SizedBox(height: 6),
                      AppButton(
                        label: l10n.rejectButton,
                        onPressed: () {
                          context.read<AdminPendingRequestsBloc>().add(
                                RejectAdminRequestEvent(requestId: request.id),
                              );
                        },
                        size: AppButtonSize.small,
                        variant: AppButtonVariant.secondary,
                        fullWidth: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PendingRequestDetailSheet extends StatelessWidget {

  const _PendingRequestDetailSheet({
    required this.request,
    required this.l10n,
  });
  final FamilyUserEntity request;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Handle bar ──
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // ── Avatar lớn ──
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.resolve(
                      Colors.grey.shade300, Colors.grey.shade700),
                ),
              ),
              child: CircleAvatar(
                radius: 44,
                backgroundColor: context.resolve(
                    Colors.grey.shade100, const Color(0xFF2C2C2C)),
                backgroundImage: request.userAvatarUrl != null
                    ? CachedNetworkImageProvider(request.userAvatarUrl!)
                    : null,
                child: request.userAvatarUrl == null
                    ? Icon(
                        LucideIcons.user,
                        color: context.textPrimary,
                        size: 36,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 12),

            // ── Tên ──
            Text(
              request.userFullName ?? l10n.anonymousUser,
              style: GoogleFonts.beVietnamPro(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 4),

            // ── Email ──
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.mail,
                    size: 13,
                    color: context.textSecondary.withValues(alpha: 0.7)),
                const SizedBox(width: 5),
                Text(
                  request.userEmail ?? l10n.noEmail,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: context.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Divider ──
            Divider(
                color: context.textSecondary.withValues(alpha: 0.12),
                height: 1,
                indent: 24,
                endIndent: 24),
            const SizedBox(height: 16),

            // ── Thông tin tài khoản ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel(label: l10n.accountSection, context: context),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: LucideIcons.fingerprint,
                    label: l10n.userIdLabel,
                    value: '#${request.userId}',
                    context: context,
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: LucideIcons.shieldCheck,
                    label: l10n.registeredRoleLabel,
                    value: _roleName(request.role),
                    valueColor: _roleColor(context, request.role),
                    context: context,
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: LucideIcons.clock,
                    label: l10n.statusDisplayLabel,
                    value: _statusName(request.status),
                    valueColor: context.accent,
                    context: context,
                  ),

                  // ── Thông tin thành viên user đã điền ──
                  if (request.memberData != null) ...[
                    const SizedBox(height: 20),
                    _SectionLabel(
                        label: l10n.registeredMemberInfoLabel,
                        context: context),
                    const SizedBox(height: 8),
                    if (request.memberData!.gender != null) ...[
                      _InfoRow(
                        icon: LucideIcons.users,
                        label: l10n.genderLabel,
                        value: _genderName(request.memberData!.gender!),
                        context: context,
                      ),
                    ],
                    if (request.memberData!.dateOfBirth != null) ...[
                      const SizedBox(height: 10),
                      _InfoRow(
                        icon: LucideIcons.cake,
                        label: l10n.dobLabel,
                        value: request.memberData!.dateOfBirth!,
                        context: context,
                      ),
                    ],
                    if (request.memberData!.placeOfBirth != null &&
                        request.memberData!.placeOfBirth!.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _InfoRow(
                        icon: LucideIcons.mapPin,
                        label: l10n.hometownLabel,
                        value: request.memberData!.placeOfBirth!,
                        context: context,
                      ),
                    ],
                    if (request.memberData!.maritalStatus != null) ...[
                      const SizedBox(height: 10),
                      _InfoRow(
                        icon: LucideIcons.heart,
                        label: l10n.maritalStatusShortLabel,
                        value: _maritalName(request.memberData!.maritalStatus!),
                        context: context,
                      ),
                    ],
                    if (request.memberData!.education != null &&
                        request.memberData!.education!.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _InfoRow(
                        icon: LucideIcons.graduationCap,
                        label: l10n.educationLabel,
                        value: request.memberData!.education!,
                        context: context,
                      ),
                    ],
                    if (request.memberData!.notes != null &&
                        request.memberData!.notes!.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _InfoRow(
                        icon: LucideIcons.fileText,
                        label: l10n.notesLabel,
                        value: request.memberData!.notes!,
                        context: context,
                      ),
                    ],
                  ],
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ── Buttons ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: l10n.rejectButton,
                      onPressed: () {
                        context.read<AdminPendingRequestsBloc>().add(
                              RejectAdminRequestEvent(requestId: request.id),
                            );
                        Navigator.pop(context);
                      },
                      variant: AppButtonVariant.secondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      label: l10n.approveButton,
                      onPressed: () {
                        final notes = request.memberData?.notes;
                        final userName = request.memberData?.fullName ??
                            request.userFullName ??
                            l10n.memberFallbackName;

                        context.read<AdminPendingRequestsBloc>().add(
                              ApproveAdminRequestEvent(requestId: request.id),
                            );
                        Navigator.pop(context);

                        if (notes != null && notes.isNotEmpty) {
                          _showPostApprovalDialog(userName, notes);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showPostApprovalDialog(String userName, String notes) {
    final navContext = AppRouter.rootNavigatorKey.currentContext;
    if (navContext == null) return;

    // Trích xuất tên người thân nếu ghi chú có định dạng "Cha/Mẹ: Tên" hoặc "Vợ/Chồng: Tên"
    String? suggestedName;
    for (final part in notes.split('|')) {
      final trimmed = part.trim();
      if (trimmed.startsWith('Cha/Mẹ:')) {
        suggestedName = trimmed.replaceFirst('Cha/Mẹ:', '').trim();
        break;
      } else if (trimmed.startsWith('Vợ/Chồng:')) {
        suggestedName = trimmed.replaceFirst('Vợ/Chồng:', '').trim();
        break;
      }
    }

    showDialog(
      context: navContext,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: dialogCtx.surface,
        title: Row(
          children: [
            Icon(LucideIcons.userPlus, color: dialogCtx.primary, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.createRelativeTitle,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: dialogCtx.textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          suggestedName != null
              ? l10n.createRelativeSuggestedMessage(suggestedName, userName)
              : l10n.createRelativeFallbackMessage(notes, userName),
          style: GoogleFonts.inter(
            fontSize: 13,
            color: dialogCtx.textSecondary,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              l10n.laterAction,
              style: GoogleFonts.inter(
                color: dialogCtx.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              final activeCtx = AppRouter.rootNavigatorKey.currentContext;
              if (activeCtx != null) {
                Navigator.push(
                  activeCtx,
                  SereneFadeSlidePageRoute(
                    page: AdminMemberFormPage(
                      initialFullName: suggestedName,
                      pendingChildMemberId: request.memberNodeId,
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: dialogCtx.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              l10n.createRelativeNowAction,
              style: GoogleFonts.beVietnamPro(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _roleName(String role) {
    switch (role.toUpperCase()) {
      case 'OWNER':
      case 'CREATOR':
        return l10n.roleOwner;
      case 'BRANCH_ADMIN':
      case 'EDITOR':
        return l10n.roleEditorTitle;
      default:
        return l10n.memberLabel;
    }
  }

  Color _roleColor(BuildContext context, String role) {
    switch (role.toUpperCase()) {
      case 'OWNER':
      case 'CREATOR':
        return context.primary;
      case 'BRANCH_ADMIN':
      case 'EDITOR':
        return context.resolve(Colors.indigo.shade600, Colors.indigo.shade300);
      default:
        return context.resolve(Colors.teal, Colors.teal.shade300);
    }
  }

  String _statusName(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return l10n.statusPending;
      case 'APPROVED':
        return l10n.statusApproved;
      case 'REJECTED':
        return l10n.statusRejected;
      default:
        return status;
    }
  }

  String _genderName(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return l10n.genderMale;
      case 'female':
        return l10n.genderFemale;
      default:
        return l10n.unknownLabel;
    }
  }

  String _maritalName(String status) {
    switch (status.toLowerCase()) {
      case 'single':
        return l10n.maritalSingle;
      case 'married':
        return l10n.maritalMarried;
      case 'divorced':
        return l10n.maritalDivorcedStatus;
      case 'widowed':
        return l10n.maritalWidowedShort;
      default:
        return l10n.unknownLabel;
    }
  }
}

class _InfoRow extends StatelessWidget {

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    required this.context,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final BuildContext context;

  @override
  Widget build(BuildContext outerContext) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cột trái (Icon + Nhãn) với độ rộng cố định để dóng hàng thẳng
        SizedBox(
          width: 150,
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: outerContext.textSecondary.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    color: outerContext.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),

        // Cột phải (Giá trị) dóng thẳng hàng sang phải
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.beVietnamPro(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor ?? outerContext.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {

  const _SectionLabel({required this.label, required this.context});
  final String label;
  final BuildContext context;

  @override
  Widget build(BuildContext outerContext) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: outerContext.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.beVietnamPro(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: outerContext.textSecondary,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}
