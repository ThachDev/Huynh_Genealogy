import 'package:vnlunar/vnlunar.dart';
import '../../resources/app_localizations.dart';

class LunarDateHelper {
  LunarDateHelper._();

  /// Returns the formatted lunar date string "dd/MM ÂM LỊCH" for a given solar date.
  static String getLunarDateString(DateTime solarDate, [AppLocalizations? l10n]) {
    final lunarSuffix = l10n?.lunarSuffix ?? 'ÂM LỊCH';
    final leapSuffix = l10n?.leapMonthSuffix ?? '(Nhuận)';
    try {
      final lunar = Lunar(createdFromSolar: true, date: solarDate);
      final dayStr = lunar.day.toString().padLeft(2, '0');
      final monthStr = lunar.month.toString().padLeft(2, '0');
      final leapStr = lunar.leapMonth == true ? ' $leapSuffix' : '';
      return "$dayStr/$monthStr$leapStr $lunarSuffix";
    } catch (_) {
      final dayStr = solarDate.day.toString().padLeft(2, '0');
      final monthStr = solarDate.month.toString().padLeft(2, '0');
      return "$dayStr/$monthStr $lunarSuffix";
    }
  }
}
