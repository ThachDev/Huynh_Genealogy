/// Entity chứa dữ liệu xuất bản Phả Ký được tính toán và chuẩn hoá từ Backend
class FamilyBookStatsEntity {
  const FamilyBookStatsEntity({
    required this.totalGenerations,
    required this.totalMembers,
    required this.maleMembers,
    required this.femaleMembers,
    required this.aliveMembers,
    required this.deceasedMembers,
  });

  final int totalGenerations;
  final int totalMembers;
  final int maleMembers;
  final int femaleMembers;
  final int aliveMembers;
  final int deceasedMembers;
}

class MemorialCalendarItemEntity {
  const MemorialCalendarItemEntity({
    required this.memberId,
    required this.fullName,
    required this.gender,
    required this.generation,
    required this.lunarDay,
    required this.lunarMonth,
    this.dateOfDeath,
    this.lunarDeathDate,
    this.burialPlaceNotes,
  });

  final int memberId;
  final String fullName;
  final String gender;
  final int generation;
  final int lunarDay;
  final int lunarMonth;
  final String? dateOfDeath;
  final String? lunarDeathDate;
  final String? burialPlaceNotes;
}

class FamilyBookDataEntity {
  const FamilyBookDataEntity({
    required this.familyId,
    required this.stats,
    required this.memorialCalendar,
  });

  final int familyId;
  final FamilyBookStatsEntity stats;
  final List<MemorialCalendarItemEntity> memorialCalendar;
}
