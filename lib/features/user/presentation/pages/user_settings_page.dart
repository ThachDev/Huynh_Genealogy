import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../auth/auth.dart';
import 'package:giatocviet/core/widgets/app_bottom_navigation_bar.dart';

class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({super.key});

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(AuthProfileRefreshSilent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.watch<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        title: Text(
          l10n.settingsTitle,
          style: GoogleFonts.beVietnamPro(
            color: context.accent,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: context.appBarBg,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          // Profile header
          if (user != null) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [context.appBarBg, context.appBarBg],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: context.resolve(Colors.black.withValues(alpha: 0.1), Colors.transparent),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: context.accent.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: context.accent, width: 2),
                    ),
                    child: Icon(
                      LucideIcons.user,
                      color: context.accent,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullName.isNotEmpty
                          ? user.fullName
                          : l10n.roleViewer,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: context.accent,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          _buildSectionHeader(l10n.accountSectionTitle),
          _buildSettingsCard(
            children: [
              _buildSettingsTile(
                context: context,
                icon: LucideIcons.user,
                title: l10n.personalInfoLabel,
                onTap: () {},
              ),
              _buildDivider(),
              _buildSettingsTile(
                context: context,
                icon: LucideIcons.lock,
                title: l10n.accountSecurityLabel,
                onTap: () {},
              ),
              if (user != null &&
                  (user.role == 'OWNER' ||
                      user.role == 'BRANCH_ADMIN' ||
                      user.role == 'EDITOR' ||
                      user.role == 'CREATOR')) ...[
                _buildDivider(),
                _buildSettingsTile(
                  context: context,
                  icon: LucideIcons.shieldAlert,
                  title: l10n.switchToAdminLabel,
                  onTap: () {
                    UserMainNavigationPage.adminModeNotifier.value = true;
                  },
                ),
              ],
            ],
          ),
          const SizedBox(height: 24),

          _buildSectionHeader(l10n.appSettingsSection),
          _buildSettingsCard(
            children: [
              _buildSettingsTile(
                context: context,
                icon: LucideIcons.globe,
                title: l10n.languageLabel,
                onTap: () {},
              ),
              _buildDivider(),
              _buildSettingsTile(
                context: context,
                icon: LucideIcons.bellRing,
                title: l10n.notificationLabel,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),

          _buildSectionHeader(l10n.infoAndHelpSection),
          _buildSettingsCard(
            children: [
              _buildSettingsTile(
                context: context,
                icon: LucideIcons.helpCircle,
                title: l10n.helpCenterLabel,
                onTap: () {},
              ),
              _buildDivider(),
              _buildSettingsTile(
                context: context,
                icon: LucideIcons.info,
                title: l10n.aboutUsLabel,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Logout button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Text(
                      l10n.logoutLabel,
                      style: GoogleFonts.beVietnamPro(
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                    ),
                    content: Text(
                      l10n.logoutConfirmMessage,
                      style:
                          GoogleFonts.inter(color: context.textSecondary),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text(
                          l10n.cancelLabel,
                          style: GoogleFonts.inter(
                              color: context.textSecondary),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          context.read<AuthBloc>().add(AuthLogoutRequested());
                        },
                        child: Text(
                          l10n.logoutButton,
                          style: GoogleFonts.inter(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(LucideIcons.logOut, size: 18),
              label: Text(
                l10n.logoutButton,
                style: GoogleFonts.beVietnamPro(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.beVietnamPro(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: context.textSecondary.withValues(alpha: 0.7),
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: context.accent.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      color: context.surface,
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (iconColor ?? context.primary).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: iconColor ?? context.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: titleColor ?? context.textPrimary,
                ),
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              size: 16,
              color: context.textSecondary.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: context.accent.withValues(alpha: 0.05),
      indent: 60,
      endIndent: 16,
    );
  }
}
