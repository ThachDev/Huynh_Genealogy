import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../features/auth/auth.dart';
import '../../../../resources/app_localizations.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.watch<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;

    return Scaffold(
      backgroundColor: context.background,
      appBar: const AppAppBar(
        title: 'Tài Khoản',
      ),
      body: user == null
          ? const Center(child: AppLoading(size: 80))
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                // Profile header card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: context.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: context.accent.withValues(alpha: 0.1),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: context.primary.withValues(alpha: 0.1),
                        child: Text(
                          user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : 'U',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: context.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.fullName,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: context.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.email.isNotEmpty ? user.email : 'Chưa cập nhật email',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: context.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: context.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                user.role,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: context.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Settings & Action Options
                Container(
                  decoration: BoxDecoration(
                    color: context.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: context.accent.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(LucideIcons.mail, color: context.primary),
                        title: Text(
                          'Email liên hệ',
                          style: GoogleFonts.beVietnamPro(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          user.email.isNotEmpty ? user.email : '-',
                          style: GoogleFonts.inter(fontSize: 12),
                        ),
                      ),
                      const Divider(height: 1, indent: 56),
                      ListTile(
                        leading: Icon(LucideIcons.shield, color: context.primary),
                        title: Text(
                          'Vai trò dòng tộc',
                          style: GoogleFonts.beVietnamPro(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          user.role,
                          style: GoogleFonts.inter(fontSize: 12),
                        ),
                      ),
                      const Divider(height: 1, indent: 56),
                      ListTile(
                        leading: const Icon(LucideIcons.logOut, color: Colors.red),
                        title: Text(
                          l10n.logoutLabel,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                        onTap: () {
                          context.read<AuthBloc>().add(AuthLogoutRequested());
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
