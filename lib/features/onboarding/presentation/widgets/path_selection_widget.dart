import 'package:flutter/material.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/auth.dart';
import 'selection_card.dart';

/// ============================================================================
/// PRESENTATION LAYER — PATH SELECTION WIDGET
/// ============================================================================
/// Giao diện bước 1 cho phép người dùng mới lựa chọn 1 trong 2 luồng Onboarding:
///   - Path 1 (Creator): Khởi tạo dòng họ mới.
///   - Path 2 (Viewer): Gia nhập vào một dòng họ đã có sẵn.
/// ============================================================================
class PathSelectionWidget extends StatelessWidget {

  const PathSelectionWidget({
    super.key,
    required this.user,
    required this.onPathSelected,
    required this.selectedPath,
  });
  final UserEntity user;
  final ValueChanged<int> onPathSelected;
  final int? selectedPath;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: l10n.welcomeViewerTitle(user.fullName),
          description: l10n.chooseOnboardingSubtitle,
        ),
        const SizedBox(height: 32),

        // Card 1: Khởi tạo gia tộc
        SelectionCard(
          iconAssetPath: 'assets/icons/add_Family.png',
          iconColor: context.primary,
          title: l10n.createFamilyCardTitle,
          subtitle: l10n.createFamilyCardDesc,
          isSelected: selectedPath == 1,
          onTap: () => onPathSelected(1),
        ),

        const SizedBox(height: 20),

        // Card 2: Gia nhập gia tộc có sẵn
        SelectionCard(
          iconAssetPath: 'assets/icons/family.png',
          iconColor: context.accent,
          title: l10n.joinFamilyCardTitle,
          subtitle: l10n.joinFamilyCardDesc,
          isSelected: selectedPath == 2,
          onTap: () => onPathSelected(2),
        ),
      ],
    );
  }
}
