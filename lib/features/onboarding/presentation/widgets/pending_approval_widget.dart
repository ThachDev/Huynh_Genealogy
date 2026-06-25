import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/auth.dart';

class PendingApprovalWidget extends StatelessWidget {
  final UserEntity user;

  const PendingApprovalWidget({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 48),
          const Icon(
            LucideIcons.hourglass,
            size: 80,
            color: AppColors.gold,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.pendingApprovalTitle,
            style: GoogleFonts.beVietnamPro(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.crimson,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              l10n.pendingApprovalMessage,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 36),
          AppButton(
            label: l10n.checkStatusButton,
            onPressed: () {
              context.read<AuthBloc>().add(AuthCheckRequested());
            },
            fullWidth: true,
          ),
          const SizedBox(height: 16),
          AppButton(
            label: l10n.logoutTooltip,
            variant: AppButtonVariant.outline,
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
            fullWidth: true,
          ),
        ],
      ),
    );
  }
}
