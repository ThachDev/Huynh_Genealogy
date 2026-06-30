class LunarDateHelper {
  LunarDateHelper._();

  // Tet (Lunar New Year) solar date starting bounds for years 2024 to 2030
  static final Map<int, DateTime> _tetDates = {
    2024: DateTime(2024, 2, 10),
    2025: DateTime(2025, 1, 29),
    2026: DateTime(2026, 2, 17),
    2027: DateTime(2027, 2, 6),
    2028: DateTime(2028, 1, 26),
    2029: DateTime(2029, 2, 13),
    2030: DateTime(2030, 2, 3),
  };

  // Lunar month days for each lunar year (1 = 30 days, 0 = 29 days)
  // Index 0 = Jan, Index 11 = Dec.
  static const Map<int, List<int>> _lunarMonthLengths = {
    2024: [30, 29, 29, 30, 29, 30, 30, 29, 30, 30, 29, 30], // 2024 (no leap)
    2025: [29, 30, 29, 29, 30, 29, 30, 29, 30, 30, 30, 29], // 2025
    2026: [30, 29, 30, 29, 29, 30, 29, 29, 30, 30, 30, 29], // 2026
    2027: [30, 30, 29, 30, 29, 29, 30, 29, 29, 30, 30, 29], // 2027
    2028: [30, 30, 30, 29, 30, 29, 29, 30, 29, 29, 30, 29], // 2028
    2029: [30, 30, 29, 30, 30, 29, 30, 29, 30, 29, 29, 30], // 2029
    2030: [29, 30, 29, 30, 30, 29, 30, 30, 29, 30, 29, 29], // 2030
  };

  /// Returns the formatted lunar date string "dd/MM Âm Lịch" for a given solar date.
  static String getLunarDateString(DateTime solarDate) {
    if (solarDate.year < 2024 || solarDate.year > 2030) {
      return "${solarDate.day.toString().padLeft(2, '0')}/${solarDate.month.toString().padLeft(2, '0')} Âm Lịch";
    }

    int solarYear = solarDate.year;
    DateTime tetThisYear = _tetDates[solarYear]!;
    
    int lunarYear;
    int daysDiff;

    if (solarDate.isBefore(tetThisYear)) {
      lunarYear = solarYear - 1;
      DateTime tetPrevYear = _tetDates[lunarYear]!;
      daysDiff = solarDate.difference(tetPrevYear).inDays;
    } else {
      lunarYear = solarYear;
      daysDiff = solarDate.difference(tetThisYear).inDays;
    }

    if (lunarYear < 2024 || lunarYear > 2030) {
      return "${solarDate.day.toString().padLeft(2, '0')}/${solarDate.month.toString().padLeft(2, '0')} Âm Lịch";
    }

    final monthLengths = _lunarMonthLengths[lunarYear]!;
    int daysAccumulated = 0;
    int lunarMonth = 1;
    int lunarDay = 1;

    for (int i = 0; i < monthLengths.length; i++) {
      int monthDays = monthLengths[i];
      if (daysAccumulated + monthDays > daysDiff) {
        lunarMonth = i + 1;
        lunarDay = daysDiff - daysAccumulated + 1;
        break;
      }
      daysAccumulated += monthDays;
    }

    final dayStr = lunarDay.toString().padLeft(2, '0');
    final monthStr = lunarMonth.toString().padLeft(2, '0');

    return "$dayStr/$monthStr ÂM LỊCH";
  }
}
