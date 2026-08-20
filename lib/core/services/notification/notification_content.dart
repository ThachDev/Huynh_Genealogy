import '../../errors/failures.dart';

/// Loại thông báo truyền trong `data` của FCM / local push.
class NotifType {
  static const String event = 'event';
  static const String wish = 'wish';
  static const String anniversary = 'anniversary';
}

/// Kênh hiển thị thông báo local.
class NotificationChannel {
  static const String id = 'giatoc_notifications';
  static const String name = 'Thông báo Gia Tộc Việt';
}

/// Xây dựng nội dung (tiêu đề / nội dung) cho thông báo.
/// Pure class, dễ test và tái dùng giữa FCM foreground và lên lịch local.
class NotificationContentBuilder {
  const NotificationContentBuilder();

  String titleFor(Map<String, String> data) {
    final eventType = (data['eventType'] ?? '').toLowerCase();
    if (data['type'] == NotifType.wish) {
      return AppLanguage.current?.notifWishTitle ?? 'Lời chúc';
    }
    if (data['type'] == NotifType.anniversary) {
      return data['isBirthday'] == 'true'
          ? AppLanguage.current?.notifBirthdayTitle ?? 'Sinh nhật hôm nay'
          : AppLanguage.current?.notifDeathAnniversaryTitle ??
              'Ngày giỗ hôm nay';
    }
    if (eventType == 'announcement' ||
        eventType == 'notification' ||
        eventType == 'thông báo') {
      return AppLanguage.current?.notifAnnouncementTitle ??
          'Thông báo mới từ dòng họ';
    }
    return AppLanguage.current?.notifNewEventTitle ?? 'Sự kiện mới';
  }

  String bodyFor(Map<String, String> data) {
    final custom = data['body'] ?? data['title'];
    if (custom != null && custom.isNotEmpty) return custom;
    return AppLanguage.current?.notifGenericBody ?? 'Có thông báo mới từ dòng họ';
  }

  /// Xây tiêu đề + nội dung cho thông báo giỗ/sinh nhật hôm nay.
  ({String title, String body}) anniversaryText({
    required List<String> deaths,
    required List<String> births,
  }) {
    final parts = <String>[];
    if (deaths.isNotEmpty) {
      final joined = deaths.join(', ');
      parts.add(AppLanguage.current?.notifDeathOfPart(joined) ??
          'ngày giỗ của $joined');
    }
    if (births.isNotEmpty) {
      final joined = births.join(', ');
      parts.add(AppLanguage.current?.notifBirthdayOfPart(joined) ??
          'sinh nhật của $joined');
    }

    final joinedParts = parts.join(' và ');
    final title = (deaths.isNotEmpty && births.isNotEmpty)
        ? AppLanguage.current?.notifAnniversariesTodayTitle ??
            'Giỗ & Sinh nhật hôm nay'
        : (deaths.isNotEmpty
            ? AppLanguage.current?.notifDeathAnniversaryTitle ??
                'Ngày giỗ hôm nay'
            : AppLanguage.current?.notifBirthdayTitle ?? 'Sinh nhật hôm nay');
    final body = AppLanguage.current?.notifTodayBody(joinedParts) ??
        'Hôm nay là $joinedParts.';
    return (title: title, body: body);
  }
}