import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../resources/app_localizations.dart';

class AdminAboutUsPage extends StatelessWidget {
  const AdminAboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.background,
      appBar: AppAppBar(title: l10n.aboutUsTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: context.accent, width: 2),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo_launcher.png',
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.appTitle,
              style: GoogleFonts.beVietnamPro(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.aboutUsTagline,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                height: 1.6,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 32),
            _buildInfoRow(context, l10n.versionLabel, '1.0.0'),
            _buildDivider(context),
            _buildInfoRow(context, l10n.developerLabel, 'ThachDev'),
            _buildDivider(context),
            _buildInfoRow(context, l10n.contactEmailLabel, 'thachhuynh.dev@gmail.com'),
            _buildDivider(context),
            const SizedBox(height: 32),
            Text(
              l10n.copyrightText,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: context.textSecondary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.beVietnamPro(
              fontSize: 13,
              color: context.textSecondary,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: context.accent.withValues(alpha: 0.08),
    );
  }
}
