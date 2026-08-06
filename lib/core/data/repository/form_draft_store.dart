import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Lưu nháp form xuống máy để không mất dữ liệu khi bị kill app / thoát ngang.
class FormDraftStore {
  FormDraftStore._();

  static const String _prefix = 'FORM_DRAFT_';

  static Future<void> save(String key, Map<String, String> values) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('$_prefix$key', json.encode(values));
    } catch (_) {
      // Bỏ qua lỗi lưu nháp, không ảnh hưởng đến luồng chính.
    }
  }

  static Future<Map<String, String>?> load(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('$_prefix$key');
      if (raw == null) return null;
      final decoded = json.decode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded.map((k, v) => MapEntry(k, v?.toString() ?? ''));
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<void> clear(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_prefix$key');
    } catch (_) {}
  }
}
