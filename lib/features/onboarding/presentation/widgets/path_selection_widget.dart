import 'package:flutter/material.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
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
        AppSectionHeader(
          title: l10n.welcomeViewerTitle(user.fullName),
          description: l10n.chooseOnboardingSubtitle,
          titleSize: 20,
          indicatorHeight: 20,
          spacing: 8,
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
