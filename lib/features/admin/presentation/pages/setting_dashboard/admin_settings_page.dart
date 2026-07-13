import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/domain/entity/family_entity.dart';
import '../../../../../resources/app_localizations.dart';
import '../../../../auth/auth.dart';
import '../../bloc/admin_pending_requests/admin_pending_requests_bloc.dart';

import 'pages/admin_clan_and_personal_info_page.dart';
import 'pages/admin_account_security_page.dart';
import 'pages/admin_transfer_ownership_page.dart';
import 'pages/admin_dissolve_clan_page.dart';
import 'pages/admin_regulations_page.dart';
import 'pages/admin_help_center_page.dart';
import 'pages/admin_about_us_page.dart';
import 'pages/admin_member_roles_page.dart';

import '../../../../../main.dart';

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  bool _isEn = false;
  bool _isDark = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    final brightness = Theme.of(context).brightness;
    setState(() {
      _isEn = locale.languageCode == 'en';
      _isDark = brightness == Brightness.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pendingState = context.watch<AdminPendingRequestsBloc>().state;
    final FamilyEntity? family =
        pendingState is AdminPendingRequestsLoaded ? pendingState.family : null;
    final authState = context.watch<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;

    final role = user?.role ?? 'VIEWER';
    final roleUpper = role.toUpperCase();
    final hasAdminPrivileges = roleUpper == 'OWNER' ||
        roleUpper == 'BRANCH_ADMIN' ||
        roleUpper == 'EDITOR' ||
        roleUpper == 'CREATOR';

    return ValueListenableBuilder<bool>(
      valueListenable: UserMainNavigationPage.adminModeNotifier,
      builder: (context, isAdminMode, _) {
        final showAdminInterface = hasAdminPrivileges && isAdminMode;
        final isOwner = roleUpper == 'OWNER' || roleUpper == 'CREATOR';

        return Scaffold(
          backgroundColor: context.background,
          appBar: AppAppBar(
            title: showAdminInterface
                ? l10n.adminSettingsTitle
                : l10n.settingsTitle,
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: [
              _buildSettingsCard(children: [
                _buildSectionHeaderInsideCard(
                  context,
                  showAdminInterface
                      ? l10n.accountAndClanSection
                      : l10n.accountSectionTitle,
                ),
                _buildSettingsTile(
                  context: context,
                  icon: LucideIcons.user,
                  title: showAdminInterface
                      ? l10n.clanAndPersonalInfoTitle
                      : l10n.personalInfoLabel,
                  destination: AdminClanAndPersonalInfoPage(
                      family: showAdminInterface ? family : null, user: user),
                ),
                _buildSettingsTile(
                  context: context,
                  icon: LucideIcons.lock,
                  title: l10n.accountSecurityLabel,
                  destination: const AdminAccountSecurityPage(),
                ),
                if (showAdminInterface)
                  _buildSettingsTile(
                    context: context,
                    icon: LucideIcons.userCheck,
                    title: l10n.switchToMemberPage,
                    onTap: () {
                      UserMainNavigationPage.adminModeNotifier.value = false;
                    },
                  )
                else if (hasAdminPrivileges)
                  _buildSettingsTile(
                    context: context,
                    icon: LucideIcons.shieldAlert,
                    title: l10n.switchToAdminLabel,
                    onTap: () {
                      UserMainNavigationPage.adminModeNotifier.value = true;
                    },
                  ),
                _buildSectionHeaderInsideCard(context, l10n.appSettingsSection),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            LucideIcons.globe,
                            size: 22,
                            color: context.primary,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            l10n.languageLabel,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: context.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      AppCustomSwitch(
                        value: _isEn,
                        activeColor: context.primary,
                        inactiveColor: context.primary,
                        onChanged: (val) {
                          setState(() {
                            _isEn = val;
                          });
                          final newLang = val ? 'en' : 'vi';
                          FamilyTreeApp.setLocale(context, Locale(newLang));
                        },
                        activeText: 'EN',
                        inactiveText: 'VI',
                        activeIcon:
                            const Text('🇺🇸', style: TextStyle(fontSize: 16)),
                        inactiveIcon:
                            const Text('🇻🇳', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            LucideIcons.palette,
                            size: 22,
                            color: context.primary,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            l10n.themeLabel,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: context.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      AppCustomSwitch(
                        value: _isDark,
                        activeColor: context.primary,
                        inactiveColor: context.primary,
                        onChanged: (val) {
                          setState(() {
                            _isDark = val;
                          });
                          final mode = val ? ThemeMode.dark : ThemeMode.light;
                          FamilyTreeApp.setThemeMode(context, mode);
                        },
                        activeText: 'Dark',
                        inactiveText: 'Light',
                        activeIcon: Icon(LucideIcons.moon,
                            size: 14, color: context.primary),
                        inactiveIcon: const Icon(LucideIcons.sun,
                            size: 14, color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                ),
                _buildSectionHeaderInsideCard(context, l10n.infoAndHelpSection),
                _buildSettingsTile(
                  context: context,
                  icon: LucideIcons.fileText,
                  title: l10n.regulationsLabel,
                  destination: const AdminRegulationsPage(),
                ),
                _buildSettingsTile(
                  context: context,
                  icon: LucideIcons.helpCircle,
                  title: l10n.helpCenterLabel,
                  destination: const AdminHelpCenterPage(),
                ),
                _buildSettingsTile(
                  context: context,
                  icon: LucideIcons.info,
                  title: l10n.aboutUsLabel,
                  destination: const AdminAboutUsPage(),
                ),
                if (showAdminInterface && isOwner) ...[
                  _buildSectionHeaderInsideCard(
                      context, l10n.advancedAdminSection),
                  _buildSettingsTile(
                    context: context,
                    icon: LucideIcons.users,
                    title: l10n.memberRolesLabel,
                    destination: const AdminMemberRolesPage(),
                  ),
                  _buildSettingsTile(
                    context: context,
                    icon: LucideIcons.shieldAlert,
                    title: l10n.transferOwnershipLabel,
                    destination: const AdminTransferOwnershipPage(),
                  ),
                  _buildSettingsTile(
                    context: context,
                    icon: LucideIcons.trash2,
                    title: l10n.dissolveClanLabel,
                    destination: AdminDissolveClanPage(
                      familyId: family?.id ?? 0,
                      familyName: family?.name ?? l10n.appTitle,
                    ),
                    titleColor: AppColors.error,
                    iconColor: AppColors.error,
                  ),
                ],
              ]),
              const SizedBox(height: 24),
              AppButton(
                label: l10n.logoutButton,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: ctx.surface,
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
                        style: GoogleFonts.inter(color: context.textSecondary),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: Text(
                            l10n.cancelLabel,
                            style:
                                GoogleFonts.inter(color: context.textSecondary),
                          ),
                        ),
                        AppButton(
                          label: l10n.logoutButton,
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            context.read<AuthBloc>().add(AuthLogoutRequested());
                          },
                          variant: AppButtonVariant.danger,
                          size: AppButtonSize.small,
                        ),
                      ],
                    ),
                  );
                },
                prefixIcon: const Icon(LucideIcons.logOut, size: 18),
                variant: AppButtonVariant.danger,
                fullWidth: true,
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.resolve(
              Colors.black.withValues(alpha: 0.03),
              Colors.transparent,
            ),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    Widget? destination,
    VoidCallback? onTap,
    Color? titleColor,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap();
        } else if (destination != null) {
          Navigator.of(context).push(FadeScalePageRoute(page: destination));
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: iconColor ?? context.primary,
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

  Widget _buildSectionHeaderInsideCard(BuildContext context, String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, top: 20, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.beVietnamPro(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: context.primary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
