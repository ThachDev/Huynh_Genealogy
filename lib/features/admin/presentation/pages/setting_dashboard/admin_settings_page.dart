import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/data/repository/notification_settings_store.dart';
import '../../../../../core/services/notification_service.dart';
import '../../../../../resources/app_localizations.dart';
import '../../../../auth/auth.dart';
import '../../../../family_tree/family_tree.dart';
import '../../bloc/admin_pending_requests/admin_pending_requests_bloc.dart';

import 'pages/admin_clan_info_page.dart';
import 'pages/admin_account_security_page.dart';
import 'pages/admin_transfer_ownership_page.dart';
import 'pages/admin_dissolve_clan_page.dart';
import 'pages/admin_regulations_page.dart';
import 'pages/admin_help_center_page.dart';
import 'pages/admin_about_us_page.dart';
import 'pages/admin_member_roles_page.dart';
import 'pages/admin_settings_profile_card.dart';
import '../admin_dashboard/pages/admin_member_form_page.dart';
import '../admin_dashboard/pages/admin_link_accounts_page.dart';

import '../../../../../main.dart';

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  bool _isEn = false;
  bool _isDark = false;
  bool _ntfEvents = true;
  bool _ntfAnnouncements = true;
  bool _ntfWishes = true;
  bool _ntfAnniversaries = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final events = await NotificationSettingsStore.eventEnabled();
    final announcements = await NotificationSettingsStore.announcementEnabled();
    final wishes = await NotificationSettingsStore.wishEnabled();
    final anniversaries = await NotificationSettingsStore.anniversaryEnabled();
    if (!mounted) return;
    setState(() {
      _ntfEvents = events;
      _ntfAnnouncements = announcements;
      _ntfWishes = wishes;
      _ntfAnniversaries = anniversaries;
    });
  }

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
          appBar: AppAppBar(
            title: showAdminInterface
                ? l10n.adminSettingsTitle
                : l10n.settingsTitle,
          ),
          body: AppBackgroundBody(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                // ── Profile card ──────────────────────
                AdminSettingsProfileCard(user: user),
                if (isOwner &&
                    user != null &&
                    (user.memberId == null || user.memberId == 0)) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: context.primary.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(LucideIcons.userX,
                                color: context.primary, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                l10n.noProfileLink,
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: context.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.noProfileLinkDesc,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: context.textSecondary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AdminMemberFormPage(
                                    isOwnerSelfSetup: true,
                                    ownerUserId: user.id,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(LucideIcons.userPlus, size: 16),
                            label: Text(
                              l10n.createProfileButton,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                _buildSettingsCard(children: [
                  _buildSectionHeaderInsideCard(
                      context, l10n.appSettingsSection),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
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
                                  color: context.textPrimary),
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
                          activeIcon: const Text('🇺🇸',
                              style: TextStyle(fontSize: 16)),
                          inactiveIcon: const Text('🇻🇳',
                              style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
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
                                  color: context.textPrimary),
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
                  _buildSectionHeaderInsideCard(
                      context, l10n.notificationsSectionTitle),
                  _buildSettingsTile(
                    context: context,
                    icon: LucideIcons.bell,
                    title: l10n.notificationsSectionTitle,
                    trailingText: _getNotificationSummaryText(),
                    onTap: () => _showNotificationSettingsBottomSheet(
                        context, family, l10n),
                  ),
                  _buildSectionHeaderInsideCard(
                    context,
                    showAdminInterface
                        ? l10n.accountAndClanSection
                        : l10n.accountSectionTitle,
                  ),
                  if (showAdminInterface)
                    _buildSettingsTile(
                      context: context,
                      icon: LucideIcons.landmark,
                      title: l10n.clanInfoLabel,
                      destination: AdminClanInfoPage(
                        family: family,
                        user: user,
                      ),
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
                        UserMainNavigationPage.setAdminMode(false);
                      },
                    )
                  else if (hasAdminPrivileges)
                    _buildSettingsTile(
                      context: context,
                      icon: LucideIcons.shieldAlert,
                      title: l10n.switchToAdminLabel,
                      onTap: () {
                        UserMainNavigationPage.setAdminMode(true);
                      },
                    ),
                  _buildSectionHeaderInsideCard(
                      context, l10n.infoAndHelpSection),
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
                      icon: LucideIcons.link2,
                      title: l10n.linkAccountsLabel,
                      destination: const AdminLinkAccountsPage(),
                    ),
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
                  onPressed: () async {
                    final confirmed = await AppDialog.confirm(
                      context,
                      title: l10n.logoutLabel,
                      message: l10n.logoutConfirmMessage,
                      confirmLabel: l10n.logoutButton,
                      type: AppDialogType.danger,
                      showIcon: false,
                      confirmColor: context.primary,
                    );
                    if (confirmed == true && context.mounted) {
                      UserMainNavigationPage.tabIndexNotifier.value = 0;
                      context.read<AuthBloc>().add(AuthLogoutRequested());
                    }
                  },
                  prefixIcon: const Icon(LucideIcons.logOut, size: 18),
                  variant: AppButtonVariant.primary,
                  fullWidth: true,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Column(
      children: children,
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    String? trailingText,
    Widget? destination,
    VoidCallback? onTap,
    Color? titleColor,
    Color? iconColor,
  }) {
    return Column(
      children: [
        InkWell(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: titleColor ?? context.textPrimary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: context.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailingText != null) ...[
                  Text(
                    trailingText,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: context.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                Icon(
                  LucideIcons.chevronRight,
                  size: 16,
                  color: context.textSecondary.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 1,
          thickness: 0.5,
          indent: 54,
          endIndent: 16,
          color: context.textSecondary.withValues(alpha: 0.15),
        ),
      ],
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

  String _getNotificationSummaryText() {
    int count = 0;
    if (_ntfEvents) count++;
    if (_ntfAnnouncements) count++;
    if (_ntfWishes) count++;
    if (_ntfAnniversaries) count++;
    if (count == 0) return 'Đã tắt';
    return 'Đang bật ($count/4)';
  }

  void _showNotificationSettingsBottomSheet(
    BuildContext context,
    FamilyEntity? family,
    AppLocalizations l10n,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: context.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                border: Border.all(
                  color: context.primary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: context.textSecondary.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildBottomSheetNotificationItem(
                    context: context,
                    icon: LucideIcons.calendar,
                    title: l10n.notifyEventLabel,
                    subtitle: 'Cập nhật lịch sự kiện và họp mặt dòng tộc',
                    value: _ntfEvents,
                    onChanged: (v) {
                      setState(() => _ntfEvents = v);
                      setModalState(() {});
                      NotificationSettingsStore.setEvent(v);
                    },
                  ),
                  _buildBottomSheetNotificationItem(
                    context: context,
                    icon: LucideIcons.megaphone,
                    title: l10n.notifyAnnouncementLabel,
                    subtitle:
                        'Nhận tin tức và thông cáo quan trọng từ Ban Quản Trị',
                    value: _ntfAnnouncements,
                    onChanged: (v) {
                      setState(() => _ntfAnnouncements = v);
                      setModalState(() {});
                      NotificationSettingsStore.setAnnouncement(v);
                    },
                  ),
                  _buildBottomSheetNotificationItem(
                    context: context,
                    icon: LucideIcons.heart,
                    title: l10n.notifyWishLabel,
                    subtitle:
                        'Thông báo khi nhận được lời chúc từ các thành viên',
                    value: _ntfWishes,
                    onChanged: (v) {
                      setState(() => _ntfWishes = v);
                      setModalState(() {});
                      NotificationSettingsStore.setWish(v);
                    },
                  ),
                  _buildBottomSheetNotificationItem(
                    context: context,
                    icon: LucideIcons.cake,
                    title: l10n.notifyAnniversaryLabel,
                    subtitle:
                        'Thông báo nhắc lịch giỗ chạp và sinh nhật thành viên',
                    value: _ntfAnniversaries,
                    onChanged: (v) {
                      setState(() => _ntfAnniversaries = v);
                      setModalState(() {});
                      NotificationSettingsStore.setAnniversary(v);
                      final treeState = context.read<FamilyTreeBloc>().state;
                      if (treeState is FamilyTreeLoaded && family != null) {
                        NotificationService.instance
                            .scheduleTodaysAnniversaries(
                          familyId: family.id,
                          members: treeState.members,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBottomSheetNotificationItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: context.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: context.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: context.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
