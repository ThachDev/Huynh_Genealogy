import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../resources/app_localizations.dart';

class AdminRegulationsPage extends StatelessWidget {
  const AdminRegulationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        title: Text(l10n.regulationsTitle),
        backgroundColor: context.appBarBg,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                'assets/images/logo_launcher.png',
                width: 96,
                height: 96,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                l10n.regulationTitle,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                ),
              ),
            ),
            Center(
              child: Text(
                l10n.regulationLastUpdated,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: context.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              number: '1',
              title: l10n.regSection1Title,
              content: l10n.regSection1Content,
            ),
            _buildSection(
              context,
              number: '2',
              title: l10n.regSection2Title,
              content: l10n.regSection2Content,
            ),
            _buildSection(
              context,
              number: '3',
              title: l10n.regSection3Title,
              content: l10n.regSection3Content,
            ),
            _buildSection(
              context,
              number: '4',
              title: l10n.regSection4Title,
              content: l10n.regSection4Content,
            ),
            _buildSection(
              context,
              number: '5',
              title: l10n.regSection5Title,
              content: l10n.regSection5Content,
            ),
            _buildSection(
              context,
              number: '6',
              title: l10n.regSection6Title,
              content: l10n.regSection6Content,
            ),
            _buildSection(
              context,
              number: '7',
              title: l10n.regSection7Title,
              content: l10n.regSection7Content,
            ),
            _buildSection(
              context,
              number: '8',
              title: l10n.regSection8Title,
              content: l10n.regSection8Content,
            ),
            _buildSection(
              context,
              number: '9',
              title: l10n.regSection9Title,
              content: l10n.regSection9Content,
            ),
            _buildSection(
              context,
              number: '10',
              title: l10n.regSection10Title,
              content: l10n.regSection10Content,
            ),
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

  Widget _buildSection(
    BuildContext context, {
    required String number,
    required String title,
    required String content,
  }) {
    return Card(
      elevation: 0,
      color: context.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: context.accent.withValues(alpha: 0.1)),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: context.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      number,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: context.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildContent(context, content),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, String text) {
    final hasBold = text.contains('**');
    if (!hasBold) {
      return Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12,
          height: 1.6,
          color: context.textPrimary,
        ),
      );
    }

    final spans = <InlineSpan>[];
    final regex = RegExp(r'\*\*(.+?)\*\*');
    int lastEnd = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: text.substring(lastEnd, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: GoogleFonts.inter(
          fontSize: 12,
          height: 1.6,
          fontWeight: FontWeight.bold,
          color: context.textPrimary,
        ),
      ));
      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd)));
    }

    return Text.rich(
      TextSpan(children: spans),
      style: GoogleFonts.inter(
        fontSize: 12,
        height: 1.6,
        color: context.textPrimary,
      ),
    );
  }
}
