import 'package:vnlunar/vnlunar.dart';

class LunarDateHelper {
  LunarDateHelper._();

  /// Returns the formatted lunar date string "dd/MM ÂM LỊCH" for a given solar date.
  static String getLunarDateString(DateTime solarDate) {
    try {
      final lunar = Lunar(createdFromSolar: true, date: solarDate);
      final dayStr = lunar.day.toString().padLeft(2, '0');
      final monthStr = lunar.month.toString().padLeft(2, '0');
      final leapStr = lunar.leapMonth == true ? ' (Nhuận)' : '';
      return "$dayStr/$monthStr$leapStr ÂM LỊCH";
    } catch (_) {
      final dayStr = solarDate.day.toString().padLeft(2, '0');
      final monthStr = solarDate.month.toString().padLeft(2, '0');
      return "$dayStr/$monthStr ÂM LỊCH";
    }
  }
}
