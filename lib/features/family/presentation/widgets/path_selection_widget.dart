import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/auth.dart';
import 'selection_card.dart';

class PathSelectionWidget extends StatelessWidget {
  final UserEntity user;
  final ValueChanged<int> onPathSelected;
  final int? selectedPath;

  const PathSelectionWidget({
    super.key,
    required this.user,
    required this.onPathSelected,
    required this.selectedPath,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 3.5,
              height: 24,
              margin: const EdgeInsets.only(top: 6, right: 12),
              decoration: BoxDecoration(
                color: AppColors.crimson,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Text(
                l10n.welcomeViewerTitle(user.fullName),
                style: GoogleFonts.beVietnamPro(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.crimson,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          l10n.chooseOnboardingSubtitle,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 32),

        // Card 1: Khởi tạo gia tộc
        SelectionCard(
          iconAssetPath: 'assets/icons/add_Family.png',
          iconColor: AppColors.crimson,
          title: l10n.createFamilyCardTitle,
          subtitle: l10n.createFamilyCardDesc,
          isSelected: selectedPath == 1,
          onTap: () => onPathSelected(1),
        ),

        const SizedBox(height: 20),

        // Card 2: Gia nhập gia tộc có sẵn
        SelectionCard(
          iconAssetPath: 'assets/icons/family.png',
          iconColor: AppColors.gold,
          title: l10n.joinFamilyCardTitle,
          subtitle: l10n.joinFamilyCardDesc,
          isSelected: selectedPath == 2,
          onTap: () => onPathSelected(2),
        ),
      ],
    );
  }
}
