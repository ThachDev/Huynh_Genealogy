import 'package:giatocviet/core/data/repository/notification_read_controller.dart';
import 'package:giatocviet/core/domain/entity/event_entity.dart';
import 'package:giatocviet/features/events/events.dart';

/// Service xử lý logic thông báo/announcement cho User dashboard.
///
/// Tách khỏi UI để:
///   - Dễ test logic filter, unread count.
///   - Tái dùng cho Notification page.
///   - Domain không phụ thuộc UI/Bloc.
class AnnouncementService {
  AnnouncementService._();

  /// Các loại event được coi là announcement/thông báo.
  static const _announcementTypes = {
    'announcement',
    'notification',
    'thông báo',
  };

  /// Lọc danh sách announcement từ events, loại bỏ đã dismiss.
  ///
  /// Kết hợp `EventEntity.isDismissed` (server) và
  /// `NotificationReadController.isDismissed` (local user action).
  static List<EventEntity> filterAnnouncements(
    List<EventEntity> events,
    NotificationReadController readController,
  ) {
    return events.where((e) {
      final type = e.type.toLowerCase();
      final isAnnounce = _announcementTypes.contains(type);
      if (!isAnnounce) return false;
      if (e.isDismissed) return false;
      if (readController.isDismissed(e.id.toString())) return false;
      return true;
    }).toList();
  }

  /// Đếm số announcement chưa đọc.
  static int countUnread(
    List<EventEntity> announcements,
    NotificationReadController readController,
  ) {
    return announcements
        .where((e) => !readController.isRead(e.id.toString()))
        .length;
  }

  /// Tạo dữ liệu cho header bell button.
  static AnnouncementHeaderData buildHeaderData(
    List<EventEntity> events,
    NotificationReadController readController,
  ) {
    final announcements = filterAnnouncements(events, readController);
    final unreadCount = countUnread(announcements, readController);
    return AnnouncementHeaderData(
      announcements: announcements,
      unreadCount: unreadCount,
    );
  }
}

/// Dữ liệu trả về cho UI header (bell button + badge).
class AnnouncementHeaderData {
  const AnnouncementHeaderData({
    required this.announcements,
    required this.unreadCount,
  });

  final List<EventEntity> announcements;
  final int unreadCount;

  bool get hasUnread => unreadCount > 0;
}