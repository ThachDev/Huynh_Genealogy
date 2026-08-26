import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vnlunar/vnlunar.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../resources/app_localizations.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_state.dart';
import '../../domain/entities/wish_entity.dart';
import '../../../events/domain/entities/event_entity.dart';
import '../../../family_tree/domain/entities/member_entity.dart';
import '../../domain/repository/wish_repository.dart';
import '../models/upcoming_anniversary.dart';
import '../widgets/wish_letter_dialog.dart';
import '../widgets/incense_offering_dialog.dart';
import 'family_highlight_card.dart';
import '../../domain/services/anniversary_calculator.dart';

// ── Data model cho 1 slide ────────────────────────────────────────────────────
class _HighlightSlide {

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
  final List<EventEntity> events;
  final List<MemberEntity> members;
  final VoidCallback onGoToEvents;
  final void Function(EventEntity event)? onGoToEventDetail;
  final VoidCallback onGoToAnniversaries;
  final VoidCallback onGoToBirthdays;
  final void Function(String memberName)? onIncenseTap;

  @override
  State<FamilyHighlightCarousel> createState() =>
      _FamilyHighlightCarouselState();
}

class _FamilyHighlightCarouselState extends State<FamilyHighlightCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ── Build danh sách slides ───────────────────────────────────────────────
  List<_HighlightSlide> _buildSlides() {
    final l10n = AppLocalizations.of(context);
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
    final authState = context.read<AuthBloc>().state;
    final userMemberId =
        authState is Authenticated ? authState.user.memberId : null;
    final upcomingBirthdays = AnniversaryCalculator.calculateBirthdays(
      widget.members,
      userMemberId: userMemberId,
    );
    final upcomingBirthday =
        upcomingBirthdays.isNotEmpty ? upcomingBirthdays.first : null;
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
        date: bDate,
        dateLabel: upcomingBirthday.solarDateLabel,
        lunarDateLabel: upcomingBirthday.lunarDateLabel,
        daysRemaining: upcomingBirthday.daysRemaining,
        onTap: widget.onGoToBirthdays,
        onActionTap: () => _openWishDialog(upcomingBirthday),
      ));
    }

    // ── Slide 3: Lễ giỗ gần nhất ────────────────────────────────────────────
    final anniversaries = AnniversaryCalculator.calculateDeathAnniversaries(
      widget.members,
      userMemberId: userMemberId,
    );
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

  @override
  Widget build(BuildContext context) {
    final slides = _buildSlides();
    if (slides.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── PageView carousel ─────────────────────────────────────────────
        SizedBox(
          height: 194,
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

    final message = await showWishLetterDialog(
      context,
      title: data.title,
      subtitle: data.solarDateLabel,
      isBirthday: data.isBirthday,
    );

    if (message != null && message.trim().isNotEmpty && mounted) {
      final newWish = WishEntity(
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

      final wishRepository = sl<WishRepository>();
      final result = await wishRepository.createWish(newWish);

      if (mounted) {
        result.fold(
          (_) => AppSnackBar.show(
            context,
            message: l10n.errorOccurred,
            type: SnackBarType.error,
          ),
          (_) => AppSnackBar.show(
            context,
            message: l10n.wishSentMessage,
            type: SnackBarType.success,
          ),
        );
      }
    }
  }

  Future<void> _openIncenseDialog(UpcomingAnniversary data) async {
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

    final message = await showIncenseDialog(
      context,
      targetName: data.title,
      subtitle: data.solarDateLabel,
    );

    if (message != null && mounted) {
      final prayerContent = message.trim().isNotEmpty
          ? message.trim()
          : l10n.incenseDefaultPrayer;

      final newWish = WishEntity(
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

      final wishRepository = sl<WishRepository>();
      final result = await wishRepository.createWish(newWish);

      if (mounted) {
        result.fold(
          (_) => AppSnackBar.show(
            context,
            message: l10n.errorOccurred,
            type: SnackBarType.error,
          ),
          (_) => AppSnackBar.show(
            context,
            message: l10n.incenseLitFor(data.title),
            type: SnackBarType.success,
          ),
        );
      }
    }
  }
}

// ── Dot Indicator ─────────────────────────────────────────────────────────────
class _DotIndicator extends StatelessWidget {

  const _DotIndicator({
    required this.count,
    required this.current,
    required this.activeColor,
  });
  final int count;
  final int current;
  final Color activeColor;

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
