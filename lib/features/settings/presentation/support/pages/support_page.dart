import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/components/theme/app_theme.dart';
import 'package:app_family_tree/components/app_bar/app_bar.dart';
import 'package:app_family_tree/features/tree/presentation/widgets/tree_background_painter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:resources/resources.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  Future<void> _launchUrlHelper(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri uri = Uri(scheme: 'mailto', path: email);
    if (!await launchUrl(uri)) {
      debugPrint('Could not launch $email');
    }
  }

  Future<void> _makeCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber.replaceAll(' ', ''));
    if (!await launchUrl(uri)) {
      debugPrint('Could not launch $phoneNumber');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: CommonAppBar(titleText: l10n.supportTitle, centerTitle: true),
      body: Stack(
        children: [
          const Positioned.fill(
            child: CustomPaint(painter: TreeBackgroundPainter()),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildContactInfo(l10n),
                const SizedBox(height: 40),
                Text(
                  l10n.supportTitle,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.crimson,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 20),
                _buildFAQItem(l10n.supportFAQ1Question, l10n.supportFAQ1Answer),
                _buildFAQItem(l10n.supportFAQ2Question, l10n.supportFAQ2Answer),
                _buildFAQItem(l10n.supportFAQ3Question, l10n.supportFAQ3Answer),
                _buildFAQItem(l10n.supportFAQ4Question, l10n.supportFAQ4Answer),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(S l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          _buildContactRow(
            Icons.email_outlined,
            l10n.supportEmailTitle,
            'thachhuynh.dev@gmail.com',
            onTap: () => _sendEmail('thachhuynh.dev@gmail.com'),
          ),
          const Divider(height: 32),
          _buildContactRow(
            Icons.phone_outlined,
            l10n.supportHotlineTitle,
            '+84 364 749 854',
            onTap: () => _makeCall('+84 364 749 854'),
          ),
          const Divider(height: 32),
          _buildContactRow(
            Icons.facebook,
            l10n.supportFacebookTitle,
            'Gia Phả Họ Huỳnh',
            onTap: () => _launchUrlHelper(
              'https://www.facebook.com/groups/giaphahohuynh/',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(
    IconData icon,
    String title,
    String content, {
    VoidCallback? onTap,
  }) {
    return Row(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.crimson, size: 20),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                content,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      iconColor: AppColors.gold,
      collapsedIconColor: AppColors.crimson,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answer,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
