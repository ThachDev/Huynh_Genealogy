import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../resources/app_localizations.dart';

/// Hiển thị sheet nhập email để liên kết tài khoản / gửi lời mời cho một nút.
/// Trả về email đã nhập, hoặc `null` nếu người dùng huỷ.
Future<String?> showLinkAccountEmailSheet(
  BuildContext context, {
  required String memberName,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final result = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (modalContext) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(modalContext).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: modalContext.surface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(
              color: modalContext.primary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: modalContext.textSecondary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: modalContext.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(LucideIcons.mail,
                          size: 20, color: modalContext.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.linkAccountsTitle,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: modalContext.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            memberName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: modalContext.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      AppValidators.validateEmail(modalContext, value),
                  decoration: InputDecoration(
                    labelText: l10n.emailLabel,
                    hintText: l10n.emailHint,
                    prefixIcon: const Icon(LucideIcons.atSign, size: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.linkAccountEmailDesc,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: modalContext.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                AppFormActionButtons(
                  saveLabel: l10n.linkButton,
                  cancelLabel: l10n.cancelLabel,
                  onSave: () {
                    if (formKey.currentState?.validate() == true) {
                      Navigator.pop(modalContext,
                          emailController.text.trim().toLowerCase());
                    }
                  },
                  onCancel: () => Navigator.pop(modalContext),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  emailController.dispose();
  return result;
}