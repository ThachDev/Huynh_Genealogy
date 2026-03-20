import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/components/theme/app_theme.dart';
import 'package:app_family_tree/features/settings/presentation/language/widgets/language_selector.dart';
import 'package:app_family_tree/components/background/app_background.dart';
import 'package:app_family_tree/components/app_bar/app_bar.dart';
import 'package:app_family_tree/components/card/common_settings_card.dart';
import 'package:resources/resources.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: CommonAppBar(titleText: S.of(context).settingsTitle, centerTitle: true),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned.fill(child: AppBackground()),
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
            children: [
              _buildSectionTitle(S.of(context).accountSection),
              CommonSettingsCard(
                children: [
                  ListTile(
                    leading: _buildIconContainer(Icons.language),
                    title: Text(
                      S.of(context).languageSelect,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    trailing: const LanguageSelector(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionTitle(S.of(context).infoAndSupport),
              CommonSettingsCard(
                padding: EdgeInsets.zero,
                children: [
                  _buildMenuItem(
                    icon: Icons.info_outline,
                    title: S.of(context).aboutAppMenuItem,
                    onTap: () => context.push('/about'),
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.privacy_tip_outlined,
                    title: S.of(context).privacyPolicyMenuItem,
                    onTap: () => context.push('/security_policy'),
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.help_outline,
                    title: S.of(context).helpAndSupportMenuItem,
                    onTap: () => context.push('/support'),
                  ),
                ],
              ),
              const SizedBox(height: 100),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
      child: Row(
        children: [
          Container(width: 4, height: 16, color: AppColors.crimson),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconContainer(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.crimson),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: _buildIconContainer(icon),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.gold),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(color: AppColors.gold.withValues(alpha: 0.2), height: 1);
  }
}
