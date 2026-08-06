/// Tập hợp callback dọn dẹp cache khi đăng xuất.
/// Mỗi feature đăng ký callback của mình để auth layer không bị ràng buộc
/// vào chi tiết cache của feature khác.
class LogoutCacheCleaner {
  LogoutCacheCleaner._();

  static Future<void> Function()? _onLogout;

  static void register(Future<void> Function() callback) {
    _onLogout = callback;
  }

  static Future<void> clearAll() async {
    try {
      await _onLogout?.call();
    } catch (_) {}
  }
}
