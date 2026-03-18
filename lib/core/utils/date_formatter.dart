import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static const String _inputFormat = 'yyyy-MM-dd';
  static const String _displayFormat = 'dd/MM/yyyy';

  /// Chuyển chuỗi ISO 8601 (yyyy-MM-dd) thành chuỗi hiển thị (dd/MM/yyyy)
  static String? formatForDisplay(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return null;
    try {
      final dt = DateFormat(_inputFormat).parseStrict(isoDate);
      return DateFormat(_displayFormat).format(dt);
    } catch (_) {
      return isoDate;
    }
  }

  /// Chuyển chuỗi hiển thị (dd/MM/yyyy) về ISO 8601 (yyyy-MM-dd) để gửi API
  static String? formatForApi(String? displayDate) {
    if (displayDate == null || displayDate.isEmpty) return null;
    try {
      final dt = DateFormat(_displayFormat).parseStrict(displayDate);
      return DateFormat(_inputFormat).format(dt);
    } catch (_) {
      return displayDate;
    }
  }

  /// Tính tuổi từ ngày sinh
  static int? calculateAge(String? dateOfBirth) {
    if (dateOfBirth == null || dateOfBirth.isEmpty) return null;
    try {
      final birth = DateFormat(_inputFormat).parseStrict(dateOfBirth);
      final now = DateTime.now();
      int age = now.year - birth.year;
      if (now.month < birth.month ||
          (now.month == birth.month && now.day < birth.day)) {
        age--;
      }
      return age;
    } catch (_) {
      return null;
    }
  }
}
