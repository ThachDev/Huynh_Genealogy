import 'package:shared_preferences/shared_preferences.dart';

/// Lưu trạng thái "đã đọc" của các thông báo xuống máy để giữ qua các lần mở app.
class NotificationReadStore {
  NotificationReadStore._();

  static const String _prefix = 'NOTIF_READ_';

  static Future<Set<String>> load(int familyId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return (prefs.getStringList('$_prefix$familyId') ?? <String>[]).toSet();
    } catch (_) {
      return <String>{};
    }
  }

  static Future<void> save(int familyId, Set<String> ids) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('$_prefix$familyId', ids.toList());
    } catch (_) {
      // Bỏ qua lỗi lưu, không làm ảnh hưởng luồng chính.
    }
  }
}