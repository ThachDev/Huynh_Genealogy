import 'package:shared_preferences/shared_preferences.dart';

/// Cài đặt bật/tắt từng loại thông báo (lưu cục bộ trên máy).
/// Áp dụng cho cả thông báo đẩy (FCM) và thông báo cục bộ (giỗ/sinh nhật).
class NotificationSettingsStore {
  NotificationSettingsStore._();

  static const String _event = 'ntf_event';
  static const String _announcement = 'ntf_announcement';
  static const String _wish = 'ntf_wish';
  static const String _anniversary = 'ntf_anniversary';

  static Future<bool> eventEnabled() async => _bool(_event, true);
  static Future<bool> announcementEnabled() async => _bool(_announcement, true);
  static Future<bool> wishEnabled() async => _bool(_wish, true);
  static Future<bool> anniversaryEnabled() async => _bool(_anniversary, true);

  static Future<void> setEvent(bool v) => _set(_event, v);
  static Future<void> setAnnouncement(bool v) => _set(_announcement, v);
  static Future<void> setWish(bool v) => _set(_wish, v);
  static Future<void> setAnniversary(bool v) => _set(_anniversary, v);

  static Future<bool> _bool(String key, bool def) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(key) ?? def;
    } catch (_) {
      return def;
    }
  }

  static Future<void> _set(String key, bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(key, value);
    } catch (_) {}
  }
}