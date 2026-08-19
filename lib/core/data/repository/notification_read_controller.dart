import 'package:flutter/foundation.dart';
import '../../di/injection_container.dart' as di;
import '../../../features/events/data/datasources/event_api_service.dart';
import '../../../features/events/domain/entities/event_entity.dart';
import 'notification_read_store.dart';

/// Điều phối trạng thái "đã đọc" của thông báo.
///
/// Dùng singleton để mọi trang (chuông badge, danh sách thông báo) đọc chung
/// một nguồn và tự rebuild khi có thay đổi. Khi chuyển sang family khác sẽ
/// nạp lại danh sách đã đọc tương ứng và đồng bộ với Server.
class NotificationReadController extends ChangeNotifier {
  NotificationReadController._();

  static final NotificationReadController instance =
      NotificationReadController._();

  final Set<String> _readIds = <String>{};
  final Set<String> _dismissedIds = <String>{};
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
  }

  /// Đồng bộ trạng thái đã đọc và đã xoá/ẩn từ server khi tải danh sách sự kiện/thông báo
  void syncFromEvents(List<EventEntity> events, int familyId) {
    _loadedFamilyId = familyId;
    var changed = false;
    for (final e in events) {
      if (e.isRead) {
        if (_readIds.add(e.id.toString())) {
          changed = true;
        }
      }
      if (e.isDismissed) {
        if (_dismissedIds.add(e.id.toString())) {
          changed = true;
        }
      }
    }
    if (changed) {
      notifyListeners();
      _persist();
    }
  }

  bool isRead(String id) => _readIds.contains(id);
  bool isDismissed(String id) => _dismissedIds.contains(id);

  Future<void> markRead(String id) async {
    if (_readIds.add(id)) {
      notifyListeners();
      await _persist();
      _syncMarkReadApi(id);
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
      _syncMarkAllReadApi();
    }
  }

  Future<void> dismiss(String id) async {
    if (_dismissedIds.add(id)) {
      notifyListeners();
      _syncDismissApi(id);
    }
  }

  Future<void> dismissAll(List<String> ids) async {
    var changed = false;
    for (final id in ids) {
      if (_dismissedIds.add(id)) changed = true;
    }
    if (changed) {
      notifyListeners();
      _syncDismissAllApi();
    }
  }

  void _syncMarkReadApi(String id) {
    try {
      final eventId = int.tryParse(id);
      if (eventId != null) {
        di.sl<EventApiService>().markEventAsRead(eventId);
      }
    } catch (_) {}
  }

  void _syncMarkAllReadApi() {
    try {
      di.sl<EventApiService>().markAllEventsAsRead();
    } catch (_) {}
  }

  void _syncDismissApi(String id) {
    try {
      final eventId = int.tryParse(id);
      if (eventId != null) {
        di.sl<EventApiService>().dismissEvent(eventId);
      }
    } catch (_) {}
  }

  void _syncDismissAllApi() {
    try {
      di.sl<EventApiService>().dismissAllEvents();
    } catch (_) {}
  }

  Future<void> _persist() async {
    if (_loadedFamilyId == null) return;
    await NotificationReadStore.save(_loadedFamilyId!, _readIds);
  }
}