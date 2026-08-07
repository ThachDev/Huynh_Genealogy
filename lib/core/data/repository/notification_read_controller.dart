import 'package:flutter/foundation.dart';
import 'notification_read_store.dart';

/// Điều phối trạng thái "đã đọc" của thông báo.
///
/// Dùng singleton để mọi trang (chuông badge, danh sách thông báo) đọc chung
/// một nguồn và tự rebuild khi có thay đổi. Khi chuyển sang family khác sẽ
/// nạp lại danh sách đã đọc tương ứng.
class NotificationReadController extends ChangeNotifier {
  NotificationReadController._();

  static final NotificationReadController instance =
      NotificationReadController._();

  final Set<String> _readIds = <String>{};
  int? _loadedFamilyId;

  /// Nạp trạng thái đã đọc cho [familyId]. Chỉ nạp thật khi khác family lần
  /// nạp trước để tránh gọi SharedPreferences nhiều lần.
  Future<void> ensureLoaded(int familyId) async {
    if (_loadedFamilyId == familyId) return;
    final ids = await NotificationReadStore.load(familyId);
    _loadedFamilyId = familyId;
    _readIds
      ..clear()
      ..addAll(ids);
    // Chưa cần notify ở đây: việc nạp xảy ra trước khi build UI hiển thị.
  }

  bool isRead(String id) => _readIds.contains(id);

  Future<void> markRead(String id) async {
    if (_readIds.add(id)) {
      notifyListeners();
      await _persist();
    }
  }

  Future<void> markAllRead(List<String> ids) async {
    var changed = false;
    for (final id in ids) {
      if (_readIds.add(id)) changed = true;
    }
    if (changed) {
      notifyListeners();
      await _persist();
    }
  }

  Future<void> _persist() async {
    if (_loadedFamilyId == null) return;
    await NotificationReadStore.save(_loadedFamilyId!, _readIds);
  }
}