import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../resources/app_localizations.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/wish_entity.dart';
import '../../domain/repository/wish_repository.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_state.dart';
import '../models/upcoming_anniversary.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/widgets.dart';
import 'incense_offering_dialog.dart';
import 'wish_letter_dialog.dart';
import '../pages/wish_wall_page.dart';

/// Card dùng cho Ngày Giỗ và Sinh Nhật theo phong cách Lịch Khối bên trái + Thông tin bên phải.
class AnniversaryCard extends StatelessWidget {
  const AnniversaryCard({
    super.key,
    required this.data,
    this.fullWidth = false,
    this.onTap,
  });
  final UpcomingAnniversary data;
  final bool fullWidth;
  final VoidCallback? onTap;

  Future<void> _openActionDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final authState = context.read<AuthBloc>().state;
    UserEntity? userProfile;

    if (authState is Authenticated) {
      userProfile = authState.user;
    } else {
      final userBlocState = context.read<UserBloc>().state;
      if (userBlocState is UserLoadedState) {
        userProfile = userBlocState.profile;
      }
    }

    if (userProfile == null) {
      AppSnackBar.show(
        context,
        message: l10n.wishLoginRequired,
        type: SnackBarType.error,
      );
      return;
    }

    final solar = data.solarDateLabel;
    final lunar = data.lunarDateLabel;
    final subtitle = lunar == null ? solar : '$solar · $lunar';

    final String? message;
    if (data.isBirthday) {
      message = await showWishLetterDialog(
        context,
        title: data.title,
        subtitle: subtitle,
        isBirthday: true,
      );
    } else {
      message = await showIncenseDialog(
        context,
        targetName: data.title,
        subtitle: subtitle,
      );
    }

    if (message != null && context.mounted) {
      final defaultContent =
          data.isBirthday ? l10n.happyBirthdayTitle : l10n.incenseDefaultPrayer;
      final prayerContent =
          message.trim().isNotEmpty ? message.trim() : defaultContent;

      final newWish = WishEntity(
        id: 0,
        familyId: userProfile.familyId ?? 0,
        memberId: data.member.id,
        senderId: userProfile.id,
        content: prayerContent,
        eventType: data.isBirthday ? 'birthday' : 'anniversary',
        createdAt: DateTime.now(),
        senderName: userProfile.fullName,
        senderAvatar: userProfile.avatarUrl,
      );

      final result = await sl<WishRepository>().createWish(newWish);
      if (context.mounted) {
        result.fold(
          (failure) {
            AppSnackBar.show(
              context,
              message: failure.message,
              type: SnackBarType.error,
            );
          },
          (_) {
            AppSnackBar.show(
              context,
              message: data.isBirthday
                  ? l10n.wishSentMessage
                  : l10n.incenseLitFor(data.title),
              type: SnackBarType.success,
            );
          },
        );
      }
    }
  }

  void _openWishWall(BuildContext context) {
    Navigator.push(
      context,
      SereneFadeSlidePageRoute(
        page: WishWallPage(
          data: data,
          wishRepository: sl<WishRepository>(),
        ),
      ),
    );
  }

  int? _calculateTurningAge() {
    if (data.member.dateOfBirth == null) return null;
    try {
      final dobStr = data.member.dateOfBirth!.trim();
      final parts = dobStr.split(RegExp(r'[-/]'));
      if (parts.isNotEmpty) {
        int? birthYear;
        if (parts[0].length == 4) {
          birthYear = int.tryParse(parts[0]);
        } else if (parts.length >= 3 && parts[2].length == 4) {
          birthYear = int.tryParse(parts[2]);
        }
        if (birthYear != null && birthYear > 1900) {
          final targetYear = data.targetDate?.year ??
              (DateTime.now().year + (data.daysRemaining > 0 ? 0 : 1));
          final age = targetYear - birthYear;
          return age > 0 ? age : null;
        }
      }
    } catch (_) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isBirthday = data.isBirthday;

    if (isBirthday) {
      return _buildBirthdayCard(context, l10n);
    }
    return _buildAnniversaryCard(context, l10n);
  }

  /// ── Option 3: Dạng Thiệp Mừng (Celebration Card) + Nút Chúc Nhanh 💌 ──
  Widget _buildBirthdayCard(BuildContext context, AppLocalizations l10n) {
    final isToday = data.daysRemaining == 0;
    final countdownText =
        isToday ? l10n.todayLabel : l10n.eventCountdown(data.daysRemaining);
    final turningAge = _calculateTurningAge();

    final initials = data.title.isNotEmpty ? data.title[0].toUpperCase() : 'M';

    // Tuổi mừng thay vào chỗ đời thứ
    final ageText = turningAge != null
        ? (turningAge >= 60 ? 'Thọ $turningAge tuổi' : '$turningAge tuổi')
        : l10n.memberBirthdayLabel;

    return InkWell(
      onTap: onTap ?? () => _openWishWall(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: fullWidth ? double.infinity : 270,
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: context.accent.withValues(alpha: 0.12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withValues(alpha: context.isDarkMode ? 0.2 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // ── Bên trái: Avatar thành viên (bỏ viền đỏ, viền nhẹ trung tính) ──
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.textSecondary.withValues(alpha: 0.08),
                    border: Border.all(
                      color: context.textSecondary.withValues(alpha: 0.15),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: data.member.avatarUrl != null &&
                          data.member.avatarUrl!.trim().isNotEmpty
                      ? ClipOval(
                          child: AppNetworkImage(
                            url: data.member.avatarUrl!.trim(),
                            width: 50,
                            height: 50,
                          ),
                        )
                      : Text(
                          initials,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: context.primary,
                          ),
                        ),
                ),
                // Badge bánh kem nhỏ ở góc
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: context.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.surface,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        LucideIcons.cake,
                        size: 10.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 14),

            // ── Ở giữa: Tên + Ngày sinh & Tuổi mừng + Đếm ngược ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hàng 1: Tên thành viên
                  Text(
                    data.title,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),

                  // Hàng 2: Ngày sinh + Tuổi mừng (Bỏ phần Đời thứ)
                  Text(
                    '${data.solarDateLabel} • $ageText',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: context.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),

                  // Hàng 3: Đếm ngược
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isToday ? LucideIcons.sparkles : LucideIcons.alarmClock,
                        size: 12,
                        color: context.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        countdownText,
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: context.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ── Bên phải: Nút Gửi lời chúc 💌 (Màu Crimson & Text trắng) ──
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _openActionDialog(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: context.primary,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: context.primary.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      LucideIcons.heartHandshake,
                      size: 13,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.sendWishButton,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ── Option 1: Thẻ Tưởng Niệm Đồng Bộ + Nút "Dâng hương 🙏" ──
  Widget _buildAnniversaryCard(BuildContext context, AppLocalizations l10n) {
    final isToday = data.daysRemaining == 0;
    final countdownText =
        isToday ? l10n.todayLabel : l10n.eventCountdown(data.daysRemaining);

    final initials = data.title.isNotEmpty ? data.title[0].toUpperCase() : 'C';

    final dateInfo =
        data.lunarDateLabel != null && data.lunarDateLabel!.trim().isNotEmpty
            ? (data.lunarDateLabel!.contains('ÂL')
                ? '${data.lunarDateLabel} • ${data.solarDateLabel}'
                : '${data.lunarDateLabel} ÂL • ${data.solarDateLabel}')
            : data.solarDateLabel;

    return InkWell(
      onTap: onTap ?? () => _openWishWall(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: fullWidth ? double.infinity : 270,
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: context.accent.withValues(alpha: 0.12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withValues(alpha: context.isDarkMode ? 0.2 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // ── Bên trái: Avatar người đã khuất + Badge Ngọn lửa / Nhang 🕯️ ──
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.textSecondary.withValues(alpha: 0.08),
                    border: Border.all(
                      color: context.textSecondary.withValues(alpha: 0.15),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: data.member.avatarUrl != null &&
                          data.member.avatarUrl!.trim().isNotEmpty
                      ? ClipOval(
                          child: AppNetworkImage(
                            url: data.member.avatarUrl!.trim(),
                            width: 50,
                            height: 50,
                          ),
                        )
                      : Text(
                          initials,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: context.primary,
                          ),
                        ),
                ),
                // Badge ngọn lửa ở góc
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: context.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.surface,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        LucideIcons.flame,
                        size: 11,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 14),

            // ── Ở giữa: Tên người đã khuất + Ngày Âm/Dương + Đếm ngược ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hàng 1: Tên
                  Text(
                    data.title,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),

                  // Hàng 2: Ngày âm lịch & Dương lịch
                  Text(
                    dateInfo,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: context.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),

                  // Hàng 3: Đếm ngược
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isToday ? LucideIcons.sparkles : LucideIcons.alarmClock,
                        size: 12,
                        color: context.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        countdownText,
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: context.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ── Bên phải: Nút Dâng hương 🙏 (Màu Crimson & Text trắng) ──
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _openActionDialog(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: context.primary,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: context.primary.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      LucideIcons.flame,
                      size: 13,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.offerIncenseButton,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
