import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/components/theme/app_theme.dart';
import 'package:app_family_tree/components/app_bar/app_bar.dart';
import 'package:app_family_tree/features/tree/presentation/widgets/tree_background_painter.dart';
import 'package:resources/resources.dart';

class SecurityPolicyPage extends StatelessWidget {
  const SecurityPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: CommonAppBar(
        titleText: l10n.securityTitle,
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned.fill(
            child: CustomPaint(painter: TreeBackgroundPainter()),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPolicySection(
                  l10n.securityPart1Title,
                  l10n.securityPart1Content,
                ),
                const SizedBox(height: 24),
                _buildPolicySection(
                  l10n.securityPart2Title,
                  l10n.securityPart2Content,
                ),
                const SizedBox(height: 24),
                _buildPolicySection(
                  l10n.securityPart3Title,
                  l10n.securityPart3Content,
                ),
                const SizedBox(height: 24),
                _buildPolicySection(
                  l10n.securityPart4Title,
                  l10n.securityPart4Content,
                ),
                const SizedBox(height: 24),
                _buildPolicySection(
                  l10n.securityPart5Title,
                  l10n.securityPart5Content,
                ),
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    l10n.securityLastUpdate('Tháng 3, 2026'),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicySection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.crimson,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textPrimary,
            height: 1.6,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
