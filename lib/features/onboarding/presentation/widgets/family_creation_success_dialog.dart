import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/domain/entity/family_entity.dart';

class FamilyCreationSuccessDialog extends StatefulWidget {
  final FamilyEntity family;
  final VoidCallback onProceed;

  const FamilyCreationSuccessDialog({
    super.key,
    required this.family,
    required this.onProceed,
  });

  @override
  State<FamilyCreationSuccessDialog> createState() =>
      _FamilyCreationSuccessDialogState();
}

class _FamilyCreationSuccessDialogState
    extends State<FamilyCreationSuccessDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _copyToClipboard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Clipboard.setData(ClipboardData(text: widget.family.inviteCode));
    AppSnackBar.success(
      context,
      l10n.inviteCodeCopied(widget.family.inviteCode),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              color: context.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: context.accent.withValues(alpha: 0.6),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: context.resolve(Colors.black.withValues(alpha: 0.3), Colors.transparent),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Celebration Badge
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: context.primary.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: context.accent,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          LucideIcons.check,
                          color: context.accent,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Success Title
                      Text(
                        l10n.creationSuccessTitle,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: context.accent,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Family Name
                      Text(
                        widget.family.name.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: context.primary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Invite Code Box
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: context.background,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: context.accent.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.inviteCodeSectionLabel,
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: context.textSecondary,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.family.inviteCode,
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: context.primary,
                                    letterSpacing: 3.0,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(LucideIcons.copy,
                                  color: context.accent),
                              tooltip: l10n.copyCodeTooltip,
                              onPressed: () => _copyToClipboard(context),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Action Buttons
                      AppButton(
                        label: l10n.startExploringButton,
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.onProceed();
                        },
                        fullWidth: true,
                        size: AppButtonSize.large,
                      ),
                      const SizedBox(height: 10),
                      TextButton.icon(
                        onPressed: () {
                          final shareText = l10n.shareFamilyContent(
                            widget.family.name,
                            widget.family.inviteCode,
                          );
                          Clipboard.setData(
                            ClipboardData(text: shareText),
                          );
                          AppSnackBar.success(
                              context, l10n.copiedShareContent);
                        },
                        icon: Icon(LucideIcons.share2,
                            size: 16, color: context.primary),
                        label: Text(
                          l10n.shareFamilyButton,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: context.primary,
                          ),
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
    );
  }
}
