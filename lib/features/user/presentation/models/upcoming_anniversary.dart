import '../../../../core/domain/entity/member_entity.dart';

/// Sự kiện sắp tới dùng chung cho Ngày Giỗ (isBirthday: false) và Sinh Nhật (isBirthday: true).
class UpcomingAnniversary {

  const UpcomingAnniversary({
    required this.member,
    required this.title,
    required this.solarDateLabel,
    this.lunarDateLabel,
    required this.daysRemaining,
    required this.isBirthday,
    this.targetDate,
  });
  final MemberEntity member;
  final String title;
  final String solarDateLabel;
  final String? lunarDateLabel;
  final int daysRemaining;
  final bool isBirthday;
  final DateTime? targetDate;
}
