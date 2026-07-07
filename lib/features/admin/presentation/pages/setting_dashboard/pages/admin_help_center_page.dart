import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../resources/app_localizations.dart';

class AdminHelpCenterPage extends StatelessWidget {
  const AdminHelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        title: Text(l10n.helpCenterTitle),
        backgroundColor: context.appBarBg,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, l10n.contactSection),
            const SizedBox(height: 16),
            _buildContactRow(context),
            const SizedBox(height: 32),
            _buildSectionTitle(context, l10n.accountLoginSection),
            const SizedBox(height: 16),
            _buildFaqItem(
              context: context,
              question: l10n.faqRegisterQuestion,
              answer: l10n.faqRegisterAnswer,
            ),
            _buildFaqItem(
              context: context,
              question: l10n.faqForgotPasswordQuestion,
              answer: l10n.faqForgotPasswordAnswer,
            ),
            _buildFaqItem(
              context: context,
              question: l10n.faqChangePasswordQuestion,
              answer: l10n.faqChangePasswordAnswer,
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(context, l10n.genealogyMemberSection),
            const SizedBox(height: 16),
            _buildFaqItem(
              context: context,
              question: l10n.faqAddMemberQuestion,
              answer: l10n.faqAddMemberAnswer,
            ),
            _buildFaqItem(
              context: context,
              question: l10n.faqAddBranchQuestion,
              answer: l10n.faqAddBranchAnswer,
            ),
            _buildFaqItem(
              context: context,
              question: l10n.faqEditMemberQuestion,
              answer: l10n.faqEditMemberAnswer,
            ),
            _buildFaqItem(
              context: context,
              question: l10n.faqDeleteMemberQuestion,
              answer: l10n.faqDeleteMemberAnswer,
            ),
            _buildFaqItem(
              context: context,
              question: l10n.faqImportGenealogyQuestion,
              answer: l10n.faqImportGenealogyAnswer,
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(context, l10n.clanAndRolesSection),
            const SizedBox(height: 16),
            _buildFaqItem(
              context: context,
              question: l10n.faqInviteCodeQuestion,
              answer: l10n.faqInviteCodeAnswer,
            ),
            _buildFaqItem(
              context: context,
              question: l10n.faqRolesQuestion,
              answer: l10n.faqRolesAnswer,
            ),
            _buildFaqItem(
              context: context,
              question: l10n.faqAssignRoleQuestion,
              answer: l10n.faqAssignRoleAnswer,
            ),
            _buildFaqItem(
              context: context,
              question: l10n.faqTransferOwnershipQuestion,
              answer: l10n.faqTransferOwnershipAnswer,
            ),
            _buildFaqItem(
              context: context,
              question: l10n.faqDissolveClanQuestion,
              answer: l10n.faqDissolveClanAnswer,
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(context, l10n.techSecuritySection),
            const SizedBox(height: 16),
            _buildFaqItem(
              context: context,
              question: l10n.faqDataSecurityQuestion,
              answer: l10n.faqDataSecurityAnswer,
            ),
            _buildFaqItem(
              context: context,
              question: l10n.faqDeleteAccountQuestion,
              answer: l10n.faqDeleteAccountAnswer,
            ),
            _buildFaqItem(
              context: context,
              question: l10n.faqMultiDeviceQuestion,
              answer: l10n.faqMultiDeviceAnswer,
            ),
            _buildFaqItem(
              context: context,
              question: l10n.faqEnglishSupportQuestion,
              answer: l10n.faqEnglishSupportAnswer,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: context.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.beVietnamPro(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: context.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildContactCard(
            context: context,
            icon: LucideIcons.phoneCall,
            title: l10n.hotlineTitle,
            value: l10n.hotlineValue,
            subtitle: l10n.hotlineSubtitle,
            onTap: () => launchUrl(Uri.parse('tel:19008888')),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: _buildContactCard(
            context: context,
            icon: LucideIcons.mail,
            title: l10n.supportEmailTitle,
            value: l10n.supportEmailValue,
            subtitle: l10n.supportEmailSubtitle,
            onTap: () => launchUrl(
              Uri(
                scheme: 'mailto',
                path: 'thachhuynh.dev@gmail.com',
                query: 'subject=${Uri.encodeComponent(l10n.emailSubjectHelp)}',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.accent.withValues(alpha: 0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: context.primary, size: 24),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: context.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: context.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem({
    required BuildContext context,
    required String question,
    required String answer,
  }) {
    return Card(
      elevation: 0,
      color: context.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: context.accent.withValues(alpha: 0.1)),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          question,
          style: GoogleFonts.beVietnamPro(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: context.textPrimary,
          ),
        ),
        iconColor: context.primary,
        collapsedIconColor: context.textSecondary,
        collapsedShape: const RoundedRectangleBorder(),
        shape: const RoundedRectangleBorder(),
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        children: [
          Text(
            answer,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: context.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
