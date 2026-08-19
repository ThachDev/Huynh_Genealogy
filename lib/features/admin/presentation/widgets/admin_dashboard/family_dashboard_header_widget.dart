import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_network_image.dart';
import '../../../../../core/widgets/app_shimmer.dart';
import '../../../../../core/widgets/app_snackbar.dart';
import '../../../../../resources/app_localizations.dart';
import '../../../../auth/domain/entities/user_entity.dart';

/// Widget Header dùng chung cho cả Admin Dashboard và User Dashboard
class FamilyDashboardHeaderWidget extends StatelessWidget {
  final UserEntity? user;
  final String familyName;
  final String inviteCode;
  final String? logoUrl;
  final bool isLoading;
  final bool showRoleTag;
  final Widget? trailingAction;

  const FamilyDashboardHeaderWidget({
    super.key,
    required this.user,
    required this.familyName,
    required this.inviteCode,
    this.logoUrl,
    this.isLoading = false,
    this.showRoleTag = false,
    this.trailingAction,
  });

  static String roleLabel(String? role, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (role?.toUpperCase()) {
      case 'OWNER':
      case 'CREATOR':
        return l10n.roleOwner;
      case 'BRANCH_ADMIN':
      case 'EDITOR':
        return l10n.roleEditorTitle;
      case 'VIEWER':
      case 'MEMBER':
        return l10n.memberLabel;
      default:
        return l10n.memberLabel;
    }
  }

  Widget _buildFallbackLogo() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'assets/images/logo.png',
          width: 32,
          height: 32,
          fit: BoxFit.contain,
          color: const Color(0xFFFFD700),
          errorBuilder: (context, error, stackTrace) => const Icon(
            LucideIcons.shield,
            color: Color(0xFFFFD700),
            size: 24,
          ),
        ),
      ),
    );
  }

  Future<Uint8List?> _captureQr(GlobalKey key) async {
    try {
      final boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final image = await boundary.toImage(pixelRatio: 4.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  void _showQrDialog(BuildContext context, String code) {
    final qrKey = GlobalKey();
    showDialog(
      context: context,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx)!;
        return Dialog(
          backgroundColor: ctx.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Stack(
            children: [
              Container(
                width: 340,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.qrDialogTitle,
                      style: GoogleFonts.beVietnamPro(
                        fontWeight: FontWeight.bold,
                        color: ctx.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RepaintBoundary(
                      key: qrKey,
                      child: Container(
                        width: 260,
                        height: 260,
                        padding: const EdgeInsets.all(16),
                        color: Colors.white,
                        child: QrImageView(
                          data: code,
                          version: QrVersions.auto,
                          size: 260.0,
                          gapless: false,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            label: l10n.downloadLabel,
                            onPressed: () async {
                              final bytes = await _captureQr(qrKey);
                              if (bytes == null) return;
                              try {
                                await Gal.putImageBytes(bytes,
                                    name: 'qr_$code');
                                if (ctx.mounted) {
                                  AppSnackBar.success(ctx, l10n.qrSaved);
                                }
                              } catch (e) {
                                if (ctx.mounted) {
                                  AppSnackBar.error(ctx, l10n.qrSaveError);
                                }
                              }
                            },
                            prefixIcon:
                                const Icon(LucideIcons.download, size: 16),
                            variant: AppButtonVariant.secondary,
                            size: AppButtonSize.medium,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppButton(
                            label: l10n.shareLabel,
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: code));
                              if (ctx.mounted) {
                                Navigator.pop(ctx);
                                AppSnackBar.success(
                                    context, l10n.inviteCodeCopied(code));
                              }
                            },
                            prefixIcon: const Icon(LucideIcons.copy,
                                size: 16, color: Colors.white),
                            variant: AppButtonVariant.primary,
                            size: AppButtonSize.medium,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(LucideIcons.x, color: ctx.textSecondary),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInviteCodeCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: AppShimmer(
          child: SkeletonBox(height: 100, borderRadius: 16),
        ),
      );
    }

final displayFamilyName = familyName.trim().toLowerCase().startsWith('họ')
    ? familyName.trim()
    : l10n.familyNamePrefix(familyName.trim());

    final bool isDark = context.isDarkMode;
    final Color cardBg =
        isDark ? const Color(0xFF2A231F) : const Color(0xFFFFFBF2);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border:
            Border.all(color: context.textSecondary.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Seal Logo
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF800000),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: (logoUrl != null && logoUrl!.isNotEmpty)
                  ? AppNetworkImage(
                      url: logoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context) => _buildFallbackLogo(),
                    )
                  : _buildFallbackLogo(),
            ),
          ),
          const SizedBox(width: 14),
          // Center Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  displayFamilyName,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.clanCodeLabel,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: context.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: context.textSecondary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        inviteCode.isNotEmpty ? inviteCode : '---',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: context.textPrimary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    if (inviteCode.isNotEmpty)
                      InkWell(
                        borderRadius: BorderRadius.circular(4),
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: inviteCode));
                          AppSnackBar.success(
                              context, l10n.inviteCodeCopied(inviteCode));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color:
                                context.textSecondary.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            LucideIcons.copy,
                            size: 13,
                            color: context.textSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // Vertical Divider
          Container(
            width: 1,
            height: 56,
            color: context.textSecondary.withValues(alpha: 0.1),
            margin: const EdgeInsets.symmetric(horizontal: 10),
          ),
          // Right QR
          InkWell(
            onTap: () {
              if (inviteCode.isNotEmpty) {
                _showQrDialog(context, inviteCode);
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: context.textSecondary.withValues(alpha: 0.1)),
                  ),
                  child: QrImageView(
                    data: inviteCode.isEmpty ? 'GIA_TOC_VIET' : inviteCode,
                    version: QrVersions.auto,
                    size: 42.0,
                    padding: EdgeInsets.zero,
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.qrCodeLabel,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 10,
                    color: const Color(0xFF800000),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.appBarBg,
        image: DecorationImage(
          image: AssetImage(
            context.isDarkMode
                ? 'assets/images/background_appbar_dark.png'
                : 'assets/images/background_appbar_light.png',
          ),
          fit: BoxFit.cover,
          onError: (_, __) {},
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(color: context.appBarOverlay),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top Row: Xin chào + (Optional Role Tag)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                  child: Row(
                    children: [
                      Text(
                        l10n.helloLabel,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 16,
                          color: context.textSecondary,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${user?.fullName ?? l10n.youLabel}!',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (showRoleTag) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: context.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            user != null
                                ? roleLabel(user?.role, context)
                                : l10n.clanLabel,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: context.textOnPrimary,
                            ),
                          ),
                        ),
                      ],
                      if (trailingAction != null) ...[
                        const SizedBox(width: 8),
                        trailingAction!,
                      ],
                    ],
                  ),
                ),
                // Card Mã Gia Tộc & QR Đồng Bộ
                _buildInviteCodeCard(context),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
