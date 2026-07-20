import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../resources/app_localizations.dart';

class AdminAboutUsPage extends StatefulWidget {
  const AdminAboutUsPage({super.key});

  @override
  State<AdminAboutUsPage> createState() => _AdminAboutUsPageState();
}

class _AdminAboutUsPageState extends State<AdminAboutUsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _contentFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _logoScale = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
    );
    _contentFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppAppBar(title: l10n.aboutUsTitle),
      body: AppBackgroundBody(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              // ── Animated Logo ──
              ScaleTransition(
                scale: _logoScale,
                child: Center(
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: context.isDarkMode
                          ? Colors.black.withValues(alpha: 0.3)
                          : Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: context.primary.withValues(alpha: 0.15),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/logo_launcher.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── App Name ──
              Text(
                l10n.appTitle,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: context.primary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 24),

              // ── Fade In Content ──
              FadeTransition(
                opacity: _contentFade,
                child: Column(
                  children: [
                    // ── Tagline (Parchment Styled Card) ──
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 24),
                      decoration: BoxDecoration(
                        color: context.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        l10n.aboutUsTagline,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 13,
                          height: 1.8,
                          color: context.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── App Information Table ──
                    Container(
                      decoration: BoxDecoration(
                        color: context.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildInfoTile(
                            context,
                            icon: LucideIcons.info,
                            label: l10n.versionLabel,
                            value: '1.0.0',
                          ),
                          _buildDivider(context),
                          _buildInfoTile(
                            context,
                            icon: LucideIcons.code2,
                            label: l10n.developerLabel,
                            value: 'ThachDev',
                          ),
                          _buildDivider(context),
                          _buildInfoTile(
                            context,
                            icon: LucideIcons.mail,
                            label: l10n.contactEmailLabel,
                            value: 'thachhuynh.dev@gmail.com',
                            isLink: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isLink = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: context.primary.withValues(alpha: 0.8),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.beVietnamPro(
              fontSize: 13,
              color: context.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isLink ? context.primary : context.textPrimary,
              ),
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
      indent: 20,
      endIndent: 20,
      color: context.textSecondary.withValues(alpha: 0.1),
    );
  }
}
