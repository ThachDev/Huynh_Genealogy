import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vnlunar/vnlunar.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../resources/app_localizations.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../../core/domain/entity/user_entity.dart';
import '../../../events/domain/entities/event_entity.dart';
import '../../../family_tree/domain/entities/member_entity.dart';
import '../../data/source/wish_api_service.dart';
import '../models/upcoming_anniversary.dart';
import '../models/wish_message.dart';
import '../widgets/wish_letter_dialog.dart';
import '../widgets/incense_offering_dialog.dart';
import 'family_highlight_card.dart';

// ── Data model cho 1 slide ────────────────────────────────────────────────────
class _HighlightSlide {
  final HighlightEventType type;
  final String title;
  final String? description;
  final String? location;
  final DateTime? date;
  final String dateLabel;
  final String? lunarDateLabel;
  final int daysRemaining;
  final VoidCallback onTap;
  final VoidCallback? onActionTap;

  const _HighlightSlide({
    required this.type,
    required this.title,
    this.description,
    this.location,
    this.date,
    required this.dateLabel,
    this.lunarDateLabel,
    required this.daysRemaining,
    required this.onTap,
    this.onActionTap,
  });
}

// ═════════════════════════════════════════════════════════════════════════════
/// Carousel lướt ngang cho phần Tiêu Điểm Dòng Họ.
///
/// Hiển thị tối đa 3 slides:
///   1. Sự kiện dòng tộc gần nhất
///   2. Sinh nhật thành viên gần nhất (dương lịch, chưa qua trong năm)
///   3. Lễ giỗ gần nhất
///
/// Ẩn hoàn toàn nếu không có slide nào.
// ═════════════════════════════════════════════════════════════════════════════
class FamilyHighlightCarousel extends StatefulWidget {
  final List<EventEntity> events;
  final List<MemberEntity> members;
  final VoidCallback onGoToEvents;
  final void Function(EventEntity event)? onGoToEventDetail;
  final VoidCallback onGoToAnniversaries;
  final VoidCallback onGoToBirthdays;
  final void Function(String memberName)? onIncenseTap;

  const FamilyHighlightCarousel({
    super.key,
    required this.events,
    required this.members,
    required this.onGoToEvents,
    this.onGoToEventDetail,
    required this.onGoToAnniversaries,
    required this.onGoToBirthdays,
    this.onIncenseTap,
  });

  @override
  State<FamilyHighlightCarousel> createState() =>
      _FamilyHighlightCarouselState();
}

class _FamilyHighlightCarouselState extends State<FamilyHighlightCarousel> {
  final PageController _pageController = PageController(viewportFraction: 1.0);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ── Build danh sách slides ───────────────────────────────────────────────
  List<_HighlightSlide> _buildSlides() {
    final l10n = AppLocalizations.of(context)!;
    final slides = <_HighlightSlide>[];
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    // ── Slide 1: Sự kiện dòng tộc gần nhất (chưa qua trong tương lai hoặc hôm nay) ──
    final upcomingEvents = widget.events.where((e) {
      final ed = DateTime.tryParse(e.eventDate);
      if (ed == null) return false;
      final edOnly = DateTime(ed.year, ed.month, ed.day);
      return !edOnly.isBefore(todayDate);
    }).toList();

    if (upcomingEvents.isNotEmpty) {
      upcomingEvents.sort((a, b) {
        final da = DateTime.tryParse(a.eventDate);
        final db = DateTime.tryParse(b.eventDate);
        if (da == null && db == null) return 0;
        if (da == null) return 1;
        if (db == null) return -1;
        return da.compareTo(db);
      });
      final event = upcomingEvents.first;
      final eventDate = DateTime.tryParse(event.eventDate);
      final eventDateOnly = eventDate != null
          ? DateTime(eventDate.year, eventDate.month, eventDate.day)
          : todayDate;
      final daysLeft = eventDateOnly.difference(todayDate).inDays;

      // Format dateLabel thân thiện hơn
      String dateLabel = event.eventDate;
      String? lunarDateLabel;

      if (eventDate != null) {
        dateLabel =
            '${eventDate.day.toString().padLeft(2, '0')}/${eventDate.month.toString().padLeft(2, '0')}/${eventDate.year}';
        try {
          final lunar = Lunar(createdFromSolar: true, date: eventDate);
          lunarDateLabel =
              '${lunar.day.toString().padLeft(2, '0')}/${lunar.month.toString().padLeft(2, '0')} ÂL';
        } catch (_) {}
      }

      final des = (event.content != null && event.content!.trim().isNotEmpty)
          ? event.content!.trim()
          : event.description;

      slides.add(_HighlightSlide(
        type: HighlightEventType.event,
        title: event.title,
        description: des,
        location: event.location,
        date: eventDate,
        dateLabel: dateLabel,
        lunarDateLabel: lunarDateLabel,
        daysRemaining: daysLeft,
        onTap: widget.onGoToEvents,
        onActionTap: widget.onGoToEventDetail != null
            ? () => widget.onGoToEventDetail!(event)
            : widget.onGoToEvents,
      ));
    }

    // ── Slide 2: Sinh nhật gần nhất (chỉ người còn sống, chưa qua trong năm) ───────
    final upcomingBirthday = _findNearestBirthday(widget.members, todayDate);
    if (upcomingBirthday != null) {
      final bday = upcomingBirthday.member.dateOfBirth;
      DateTime? bDate;
      if (bday != null) {
        final p = bday.split('-');
        if (p.length == 3) {
          final m = int.tryParse(p[1]);
          final d = int.tryParse(p[2]);
          if (m != null && d != null) {
            bDate = DateTime(todayDate.year, m, d);
            if (bDate.isBefore(todayDate)) {
              bDate = DateTime(todayDate.year + 1, m, d);
            }
          }
        }
      }

      slides.add(_HighlightSlide(
        type: HighlightEventType.birthday,
        title: upcomingBirthday.title,
        description: upcomingBirthday.member.generation != null
            ? l10n.generationLabel('${upcomingBirthday.member.generation!}')
            : l10n.clanMemberLabel,
        location: null,
        date: bDate,
        dateLabel: upcomingBirthday.solarDateLabel,
        lunarDateLabel: upcomingBirthday.lunarDateLabel,
        daysRemaining: upcomingBirthday.daysRemaining,
        onTap: widget.onGoToBirthdays,
        onActionTap: () => _openWishDialog(upcomingBirthday),
      ));
    }

    // ── Slide 3: Lễ giỗ gần nhất ────────────────────────────────────────────
    final anniversaries = _calculateDeathAnniversaries(widget.members);
    if (anniversaries.isNotEmpty) {
      final ann = anniversaries.first;
      DateTime? aDate;
      try {
        final p = ann.solarDateLabel.split('/');
        if (p.length == 3) {
          final d = int.tryParse(p[0]);
          final m = int.tryParse(p[1]);
          final y = int.tryParse(p[2]);
          if (d != null && m != null && y != null) {
            aDate = DateTime(y, m, d);
          }
        }
      } catch (_) {}

      slides.add(_HighlightSlide(
        type: HighlightEventType.anniversary,
        title: ann.title,
        description: ann.member.generation != null
            ? l10n.memorialCeremonyGenerationLabel(ann.member.generation!)
            : l10n.memorialCeremonyLabel,
        location: null,
        date: aDate,
        dateLabel: ann.solarDateLabel,
        lunarDateLabel: ann.lunarDateLabel,
        daysRemaining: ann.daysRemaining,
        onTap: widget.onGoToAnniversaries,
        onActionTap: () => _openIncenseDialog(ann),
      ));
    }

    return slides;
  }

  // ── Tìm sinh nhật gần nhất trong năm (chỉ người còn sống) ────────────
  UpcomingAnniversary? _findNearestBirthday(
    List<MemberEntity> members,
    DateTime todayDate,
  ) {
    final candidates = <UpcomingAnniversary>[];

    for (final member in members) {
      // Bỏ qua người đã mất
      if (!member.isAlive) continue;
      if (member.dateOfBirth == null || member.dateOfBirth!.isEmpty) continue;
      try {
        final parts = member.dateOfBirth!.split('-');
        if (parts.length != 3) continue;
        final month = int.tryParse(parts[1]);
        final day = int.tryParse(parts[2]);
        if (month == null || day == null) continue;

        // Sinh nhật năm nay
        var birthdayThisYear = DateTime(todayDate.year, month, day);

        // Nếu đã qua rồi → xét năm sau
        if (birthdayThisYear.isBefore(todayDate)) {
          birthdayThisYear = DateTime(todayDate.year + 1, month, day);
        }

        final daysLeft = birthdayThisYear.difference(todayDate).inDays;
        final dateLabel =
            '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}';

        String? lunarLabel;
        try {
          final lunar = Lunar(createdFromSolar: true, date: birthdayThisYear);
          lunarLabel =
              '${lunar.day.toString().padLeft(2, '0')}/${lunar.month.toString().padLeft(2, '0')} ÂL';
        } catch (_) {}

        candidates.add(UpcomingAnniversary(
          member: member,
          title: member.fullName,
          solarDateLabel: dateLabel,
          lunarDateLabel: lunarLabel,
          daysRemaining: daysLeft,
          isBirthday: true,
        ));
      } catch (_) {}
    }

    if (candidates.isEmpty) return null;
    candidates.sort((a, b) => a.daysRemaining.compareTo(b.daysRemaining));
    return candidates.first;
  }

  // ── Tính lễ giỗ (âm lịch) ────────────────────────────────────────────────
  List<UpcomingAnniversary> _calculateDeathAnniversaries(
      List<MemberEntity> members) {
    final List<UpcomingAnniversary> anniversaries = [];
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    for (final member in members) {
      if (member.isAlive) continue;

      int? lunarDay;
      int? lunarMonth;

      if (member.lunarDeathDate != null && member.lunarDeathDate!.isNotEmpty) {
        final match =
            RegExp(r'(\d+)\/(\d+)').firstMatch(member.lunarDeathDate!);
        if (match != null) {
          lunarDay = int.tryParse(match.group(1) ?? '');
          lunarMonth = int.tryParse(match.group(2) ?? '');
        }
      }

      if (lunarDay == null || lunarMonth == null) {
        if (member.dateOfDeath != null && member.dateOfDeath!.isNotEmpty) {
          try {
            final parts = member.dateOfDeath!.split('-');
            if (parts.length == 3) {
              final year = int.tryParse(parts[0]);
              final month = int.tryParse(parts[1]);
              final day = int.tryParse(parts[2]);
              if (year != null && month != null && day != null) {
                final dt = DateTime(year, month, day);
                final lunar = Lunar(createdFromSolar: true, date: dt);
                lunarDay = lunar.day;
                lunarMonth = lunar.month;
              }
            }
          } catch (_) {}
        }
      }

      if (lunarDay != null && lunarMonth != null) {
        try {
          final todayLunar = Lunar(createdFromSolar: true, date: today);
          final currentLunarYear = todayLunar.year;

          final listSolar = convertLunar2Solar(
              lunarDay, lunarMonth, currentLunarYear, false, 7);
          var solarAnniversary =
              DateTime(listSolar[2], listSolar[1], listSolar[0]);

          if (solarAnniversary.isBefore(todayDate)) {
            final nextListSolar = convertLunar2Solar(
                lunarDay, lunarMonth, currentLunarYear + 1, false, 7);
            solarAnniversary =
                DateTime(nextListSolar[2], nextListSolar[1], nextListSolar[0]);
          }

          final days = solarAnniversary.difference(todayDate).inDays;
          final solarLabel =
              '${solarAnniversary.day.toString().padLeft(2, '0')}/${solarAnniversary.month.toString().padLeft(2, '0')}/${solarAnniversary.year}';
          final lunarLabel =
              '${lunarDay.toString().padLeft(2, '0')}/${lunarMonth.toString().padLeft(2, '0')} ÂL';

          anniversaries.add(UpcomingAnniversary(
            member: member,
            title: member.fullName,
            solarDateLabel: solarLabel,
            lunarDateLabel: lunarLabel,
            daysRemaining: days,
            isBirthday: false,
          ));
        } catch (_) {}
      }
    }

    anniversaries.sort((a, b) => a.daysRemaining.compareTo(b.daysRemaining));
    return anniversaries;
  }

  @override
  Widget build(BuildContext context) {
    final slides = _buildSlides();
    if (slides.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── PageView carousel ─────────────────────────────────────────────
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: slides.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              final slide = slides[index];
              return FamilyHighlightCard(
                title: slide.title,
                description: slide.description,
                location: slide.location,
                date: slide.date,
                dateLabel: slide.dateLabel,
                lunarDateLabel: slide.lunarDateLabel,
                daysRemaining: slide.daysRemaining,
                eventType: slide.type,
                onTap: slide.onTap,
                onActionTap: slide.onActionTap,
              );
            },
          ),
        ),

        // ── Dot indicator (chỉ hiện khi > 1 slide) ───────────────────────
        if (slides.length > 1) ...[
          const SizedBox(height: 6),
          _DotIndicator(
            count: slides.length,
            current: _currentPage,
            activeColor: context.primary,
          ),
        ],
      ],
    );
  }

  Future<void> _openWishDialog(UpcomingAnniversary data) async {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.read<AuthBloc>().state;
    UserEntity? userProfile;

    if (authState is Authenticated) {
      userProfile = authState.user;
    }

    if (userProfile == null) {
      AppSnackBar.show(
        context,
        message: l10n.wishLoginRequired,
        type: SnackBarType.error,
      );
      return;
    }

    final message = await showWishLetterDialog(
      context,
      title: data.title,
      subtitle: data.solarDateLabel,
      isBirthday: data.isBirthday,
    );

    if (message != null && message.trim().isNotEmpty && mounted) {
      final newWish = WishMessage(
        id: 0,
        familyId: userProfile.familyId ?? 0,
        memberId: data.member.id,
        senderId: userProfile.id,
        content: message,
        eventType: data.isBirthday ? 'birthday' : 'anniversary',
        createdAt: DateTime.now(),
        senderName: userProfile.fullName,
        senderAvatar: userProfile.avatarUrl,
      );

      final apiService = sl<WishApiService>();
      final created = await apiService.createWish(newWish);

      if (mounted) {
        if (created != null) {
          AppSnackBar.show(
            context,
            message: l10n.wishSentMessage,
            type: SnackBarType.success,
          );
        } else {
          AppSnackBar.show(
            context,
            message: l10n.errorOccurred,
            type: SnackBarType.error,
          );
        }
      }
    }
  }

  Future<void> _openIncenseDialog(UpcomingAnniversary data) async {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.read<AuthBloc>().state;
    UserEntity? userProfile;

    if (authState is Authenticated) {
      userProfile = authState.user;
    }

    if (userProfile == null) {
      AppSnackBar.show(
        context,
        message: l10n.wishLoginRequired,
        type: SnackBarType.error,
      );
      return;
    }

    final message = await showIncenseDialog(
      context,
      targetName: data.title,
      subtitle: data.solarDateLabel,
    );

    if (message != null && mounted) {
      final prayerContent = message.trim().isNotEmpty
          ? message.trim()
          : l10n.incenseDefaultPrayer;

      final newWish = WishMessage(
        id: 0,
        familyId: userProfile.familyId ?? 0,
        memberId: data.member.id,
        senderId: userProfile.id,
        content: prayerContent,
        eventType: 'anniversary',
        createdAt: DateTime.now(),
        senderName: userProfile.fullName,
        senderAvatar: userProfile.avatarUrl,
      );

      final apiService = sl<WishApiService>();
      final created = await apiService.createWish(newWish);

      if (mounted) {
        if (created != null) {
          AppSnackBar.show(
            context,
            message: l10n.incenseLitFor(data.title),
            type: SnackBarType.success,
          );
        } else {
          AppSnackBar.show(
            context,
            message: l10n.errorOccurred,
            type: SnackBarType.error,
          );
        }
      }
    }
  }
}

// ── Dot Indicator ─────────────────────────────────────────────────────────────
class _DotIndicator extends StatelessWidget {
  final int count;
  final int current;
  final Color activeColor;

  const _DotIndicator({
    required this.count,
    required this.current,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? activeColor : activeColor.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
