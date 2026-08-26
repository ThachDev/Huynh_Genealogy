import 'package:vnlunar/vnlunar.dart';
import '../../../family_tree/domain/entities/member_entity.dart';
import '../../../family_tree/domain/services/kinship_calculator_service.dart';
import '../../presentation/models/upcoming_anniversary.dart';

/// Service tính toán các sự kiện kỷ niệm (Giỗ, Sinh nhật) từ danh sách thành viên.
///
/// Tách logic business khỏi Presentation layer để:
///   - Dễ test, tái sử dụng.
///   - Tuân thủ Clean Architecture (domain không phụ thuộc UI).
class AnniversaryCalculator {
  AnniversaryCalculator._();

  static final KinshipCalculatorService _kinshipService =
      KinshipCalculatorService();

  static String? _resolveKinshipTitle(
    MemberEntity target,
    List<MemberEntity> members,
    int? userMemberId,
  ) {
    if (userMemberId != null && userMemberId != target.id) {
      final myMember =
          members.where((m) => m.id == userMemberId).firstOrNull;
      if (myMember != null) {
        final res = _kinshipService.calculate(
          fromMember: myMember,
          toMember: target,
          allMembers: members,
        );
        if (res.fromCallsTo.isNotEmpty &&
            res.fromCallsTo != 'Đồng tộc / Chưa rõ liên kết') {
          return res.fromCallsTo;
        }
      }
    }
    return null;
  }

  /// Tính danh sách [UpcomingAnniversary] cho Ngày Giỗ (thành viên đã mất).
  static List<UpcomingAnniversary> calculateDeathAnniversaries(
    List<MemberEntity> members, {
    int? userMemberId,
  }) {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final currentLunarYear = Lunar(createdFromSolar: true, date: today).year;

    final anniversaries = <UpcomingAnniversary>[];

    for (final member in members) {
      if (member.isAlive) continue;

      final lunarDate = _extractLunarDeathDate(member);
      if (lunarDate == null) continue;

      final solarAnniversary = _nextSolarAnniversary(
        lunarDay: lunarDate.day,
        lunarMonth: lunarDate.month,
        currentLunarYear: currentLunarYear,
        todayOnly: todayOnly,
      );
      if (solarAnniversary == null) continue;

      final days = solarAnniversary.difference(todayOnly).inDays;
      final solarLabel =
          '${solarAnniversary.day.toString().padLeft(2, '0')}/${solarAnniversary.month.toString().padLeft(2, '0')}';
      final lunarLabel =
          '${lunarDate.day.toString().padLeft(2, '0')}/${lunarDate.month.toString().padLeft(2, '0')} ÂL';

      final kinship = _resolveKinshipTitle(member, members, userMemberId);
      final title =
          kinship != null ? '$kinship (${member.fullName})' : member.fullName;

      anniversaries.add(UpcomingAnniversary(
        member: member,
        title: title,
        kinshipTitle: kinship,
        solarDateLabel: solarLabel,
        lunarDateLabel: lunarLabel,
        daysRemaining: days,
        isBirthday: false,
        targetDate: solarAnniversary,
      ));
    }

    anniversaries.sort((a, b) => a.daysRemaining.compareTo(b.daysRemaining));
    return anniversaries;
  }

  /// Tính danh sách [UpcomingAnniversary] cho Sinh Nhật (thành viên còn sống).
  static List<UpcomingAnniversary> calculateBirthdays(
    List<MemberEntity> members, {
    int? userMemberId,
  }) {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);

    final birthdays = <UpcomingAnniversary>[];

    for (final m in members) {
      if (!m.isAlive || m.dateOfBirth == null || m.dateOfBirth!.isEmpty) {
        continue;
      }
      final parts = m.dateOfBirth!.split('-');
      if (parts.length != 3) continue;
      final month = int.tryParse(parts[1]);
      final day = int.tryParse(parts[2]);
      if (month == null || day == null) continue;

      var bd = DateTime(today.year, month, day);
      if (bd.isBefore(todayOnly)) {
        bd = DateTime(today.year + 1, month, day);
      }
      final daysLeft = bd.difference(todayOnly).inDays;
      final kinship = _resolveKinshipTitle(m, members, userMemberId);
      final title = kinship != null ? '$kinship (${m.fullName})' : m.fullName;

      birthdays.add(UpcomingAnniversary(
        member: m,
        title: title,
        kinshipTitle: kinship,
        solarDateLabel:
            '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}',
        daysRemaining: daysLeft,
        isBirthday: true,
        targetDate: bd,
      ));
    }

    birthdays.sort((a, b) => a.daysRemaining.compareTo(b.daysRemaining));
    return birthdays;
  }

  /// Trích xuất ngày giỗ âm lịch từ [MemberEntity].
  ///
  /// Ưu tiên `lunarDeathDate` (định dạng "dd/MM"), fallback sang chuyển đổi
  /// từ `dateOfDeath` (dương lịch) sang âm lịch.
  static _LunarDate? _extractLunarDeathDate(MemberEntity member) {
    // 1. Thử đọc lunarDeathDate: "dd/MM"
    if (member.lunarDeathDate != null && member.lunarDeathDate!.isNotEmpty) {
      final match = RegExp(r'(\d+)\/(\d+)').firstMatch(member.lunarDeathDate!);
      if (match != null) {
        final day = int.tryParse(match.group(1) ?? '');
        final month = int.tryParse(match.group(2) ?? '');
        if (day != null && month != null) {
          return _LunarDate(day: day, month: month);
        }
      }
    }

    // 2. Fallback: chuyển dateOfDeath (dương lịch) sang âm lịch
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
            return _LunarDate(day: lunar.day, month: lunar.month);
          }
        }
      } catch (_) {}
    }
    return null;
  }

  /// Tính ngày dương lịch kỷ niệm tiếp theo cho một ngày âm lịch cố định.
  ///
  /// Trả về ngày dương lịch của năm âm lịch hiện tại, hoặc năm sau nếu đã qua.
  static DateTime? _nextSolarAnniversary({
    required int lunarDay,
    required int lunarMonth,
    required int currentLunarYear,
    required DateTime todayOnly,
  }) {
    try {
      final thisYearSolar = convertLunar2Solar(
        lunarDay,
        lunarMonth,
        currentLunarYear,
        false,
      );
      var solar = DateTime(thisYearSolar[2], thisYearSolar[1], thisYearSolar[0]);

      if (solar.isBefore(todayOnly)) {
        final nextYearSolar = convertLunar2Solar(
          lunarDay,
          lunarMonth,
          currentLunarYear + 1,
          false,
        );
        solar = DateTime(nextYearSolar[2], nextYearSolar[1], nextYearSolar[0]);
      }
      return solar;
    } catch (_) {
      return null;
    }
  }
}

/// Internal helper cho ngày âm lịch (ngày, tháng).
class _LunarDate {
  const _LunarDate({required this.day, required this.month});
  final int day;
  final int month;
}