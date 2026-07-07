import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/domain/entity/family_user_entity.dart';
import '../../bloc/admin_pending_requests/admin_pending_requests_bloc.dart';
import '../../../../../resources/app_localizations.dart';

class PendingRequestItemWidget extends StatelessWidget {
  final FamilyUserEntity request;

  const PendingRequestItemWidget({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.accent.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: context.textPrimary.withValues(alpha: 0.12),
                backgroundImage: request.userAvatarUrl != null
                    ? NetworkImage(request.userAvatarUrl!)
                    : null,
                child: request.userAvatarUrl == null
                    ? Icon(LucideIcons.user, color: context.textPrimary)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.userFullName ?? l10n.anonymousUser,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      request.userEmail ?? l10n.noEmail,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: context.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<AdminPendingRequestsBloc>().add(
                            ApproveAdminRequestEvent(requestId: request.id),
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.primary,
                      foregroundColor: context.textOnPrimary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      minimumSize: const Size(85, 28),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      l10n.approveButton,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AdminPendingRequestsBloc>().add(
                            RejectAdminRequestEvent(requestId: request.id),
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.accent,
                      foregroundColor: context.textOnPrimary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      minimumSize: const Size(85, 28),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      l10n.rejectButton,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
