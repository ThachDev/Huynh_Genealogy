import 'dart:convert';
import 'dart:developer' as dev;
import 'package:app_family_tree/core/logger/log_config.dart';

/// Lớp logging trung tâm của project.
/// Sử dụng dart:developer's dev.log() — chỉ xuất hiện ở Debug Mode.
class Log {
  Log._();

  // ─── Public API ───────────────────────────────────────────────────────────

  /// Debug log 💡 — thông tin thông thường
  static void d(
    Object? message, {
    String name = '',
  }) {
    if (!LogConfig.enableGeneralLog) return;
    dev.log('💡 $message', name: name);
  }

  /// Error log 💢 — lỗi, exception
  static void e(
    Object? message, {
    String name = '',
    Object? errorObject,
    StackTrace? stackTrace,
  }) {
    if (!LogConfig.enableGeneralLog) return;
    dev.log(
      '💢 $message',
      name: name,
      error: errorObject,
      stackTrace: stackTrace,
    );
  }

  /// Format JSON Map thành string đẹp, dùng kết hợp với Log.d()
  /// Ví dụ: Log.d(Log.prettyJson(myMap));
  static String prettyJson(Map<String, dynamic> json) {
    if (!LogConfig.isPrettyJson) return json.toString();
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }
}

/// Mixin cho các class thông thường muốn log với tên class tự động.
/// Dùng cho: Service, Mapper, UseCase, v.v.
mixin LogMixin {
  String get _className => runtimeType.toString();

  void logD(Object? message) => Log.d(message, name: _className);

  void logE(
    Object? message, {
    Object? errorObject,
    StackTrace? stackTrace,
  }) =>
      Log.e(
        message,
        name: _className,
        errorObject: errorObject,
        stackTrace: stackTrace,
      );
}
