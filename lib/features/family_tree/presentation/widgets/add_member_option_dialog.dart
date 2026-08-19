import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';

enum AddMemberOption {
  selectExisting,
  createNew,
}

class AddMemberOptionDialog extends StatelessWidget {

  const AddMemberOptionDialog({
    super.key,
    required this.title,
    required this.availableCount,
  });
  final String title;
  final int availableCount;

  static Future<AddMemberOption?> show(
    BuildContext context, {
    required String title,
    required int availableCount,
  }) {
    return showDialog<AddMemberOption>(
      context: context,
      builder: (_) => AddMemberOptionDialog(
        title: title,
        availableCount: availableCount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dialogBg = context.surface;
    final textPrimary = context.textPrimary;
    final textSecondary = context.textSecondary;
    final borderColor =
        context.resolve(Colors.grey.shade200, Colors.grey.shade800);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 12,
      backgroundColor: dialogBg,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header without top-left icon & with Close button
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        l10n.addMemberChooseMethodDesc,
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Icon(
                        LucideIcons.x,
                        size: 18,
                        color: textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Option 1: Select existing member
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () =>
                    Navigator.pop(context, AddMemberOption.selectExisting),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.resolve(
                      Colors.grey.shade50,
                      Colors.white.withValues(alpha: 0.04),
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: borderColor,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: context.resolve(
                            Colors.grey.shade200,
                            Colors.grey.shade800,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          LucideIcons.link2,
                          color: textPrimary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.selectExistingMemberTitle,
                              style: GoogleFonts.inter(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              l10n.linkUnlinkedMemberLabel,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Option 2: Create new member
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.pop(context, AddMemberOption.createNew),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.resolve(
                      Colors.grey.shade50,
                      Colors.white.withValues(alpha: 0.04),
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: borderColor,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: context.resolve(
                            Colors.grey.shade200,
                            Colors.grey.shade800,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          LucideIcons.userPlus,
                          color: textPrimary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.createNewMemberLabel,
                              style: GoogleFonts.inter(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              l10n.createNewMemberDesc,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
