import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:vnlunar/vnlunar.dart';

import '../data/repository/notification_settings_store.dart';
import '../domain/entity/member_entity.dart';

/// Loại thông báo truyền trong `data` của FCM / local push.
class NotifType {
  static const String event = 'event';
  static const String wish = 'wish';
  static const String anniversary = 'anniversary';
}

/// Quản lý toàn bộ thông báo: đăng ký FCM token, nhận tin (foreground/
/// background), hiển thị bằng [FlutterLocalNotificationsPlugin] tôn trọng
/// cài đặt từng loại, lên lịch giỗ/sinh nhật và điều hướng khi tap.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  static const String channelId = 'giatoc_notifications';
  static const String channelName = 'Thông báo Gia Tộc Việt';

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  String? _token;
  String? get token => _token;

  /// Được nối ở tầng UI: quyết định điều hướng khi user tap 1 thông báo.
  void Function(Map<String, String> data)? onTap;

  /// Khởi tạo plugin khi app mở (gọi ở `main()`).
  Future<void> initialize() async {
    tzdata.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
    } catch (_) {}

    const android = AndroidInitializationSettings('@mipmap/launcher_icon');
    const darwin = DarwinInitializationSettings();
    await _local.initialize(
      const InitializationSettings(android: android, iOS: darwin),
      onDidReceiveNotificationResponse: (resp) {
        if (resp.payload != null) _routePayload(resp.payload!);
      },
    );
    await _createChannel();

    try {
      _token = await _messaging.getToken();
    } catch (_) {}
    _messaging.onTokenRefresh.listen((t) => _token = t);

    FirebaseMessaging.onMessage.listen((message) {
      _showIfEnabled(message.data);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _routeData(message.data);
    });
  }

  /// Đăng ký handler nền (app tắt / ở nền). Gọi 1 lần trong `main()`.
  void setupBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  }

  /// Xử lý tap vào push khi app khởi động từ trạng thái tắt.
  Future<void> handleInitialMessage() async {
    try {
      final message = await _messaging.getInitialMessage();
      if (message != null) _routeData(message.data);
    } catch (_) {}
  }

  /// Sau khi user đăng nhập: xin quyền + đảm bảo token đã có.
  Future<void> onUserLoggedIn() async {
    await _ensurePermission();
    if (_token == null) {
      try {
        _token = await _messaging.getToken();
      } catch (_) {}
    }
  }

  Future<void> _ensurePermission() async {
    try {
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      await _local
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } catch (_) {}
  }

  Future<void> _createChannel() async {
    try {
      await _local
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(const AndroidNotificationChannel(
            channelId,
            channelName,
            importance: Importance.high,
          ));
    } catch (_) {}
  }

  Future<void> _showIfEnabled(Map<String, dynamic> data) async {
    final map = data.map((k, v) => MapEntry(k, v?.toString() ?? ''));
    await _show(map, _titleFor(map), _bodyFor(map));
  }

  String _titleFor(Map<String, String> data) {
    final eventType = (data['eventType'] ?? '').toLowerCase();
    if (data['type'] == NotifType.wish) return 'Lời chúc';
    if (data['type'] == NotifType.anniversary) {
      return data['isBirthday'] == 'true'
          ? 'Sinh nhật hôm nay'
          : 'Ngày giỗ hôm nay';
    }
    if (eventType == 'announcement' ||
        eventType == 'notification' ||
        eventType == 'thông báo') {
      return 'Thông báo mới từ dòng họ';
    }
    return 'Sự kiện mới';
  }

  String _bodyFor(Map<String, String> data) {
    final custom = data['body'] ?? data['title'];
    if (custom != null && custom.isNotEmpty) return custom;
    return 'Có thông báo mới từ dòng họ';
  }

  Future<void> _show(
    Map<String, String> data,
    String title,
    String body,
  ) async {
    if (!await _isEnabled(data)) return;
    final id = _idFor(data).abs();
    await _local.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: jsonEncode(data),
    );
  }

  Future<bool> _isEnabled(Map<String, String> data) async {
    final type = data['type'];
    final eventType = (data['eventType'] ?? '').toLowerCase();
    switch (type) {
      case NotifType.event:
        if (eventType == 'announcement' ||
            eventType == 'notification' ||
            eventType == 'thông báo') {
          return NotificationSettingsStore.announcementEnabled();
        }
        return NotificationSettingsStore.eventEnabled();
      case NotifType.wish:
        return NotificationSettingsStore.wishEnabled();
      case NotifType.anniversary:
        return NotificationSettingsStore.anniversaryEnabled();
      default:
        return true;
    }
  }

  int _idFor(Map<String, String> data) {
    final stable = data['id'] ?? data['memberId'] ?? data['type'] ?? 'x';
    return (data['type'] ?? 'g').hashCode ^ stable.hashCode;
  }

  void _routeData(Map<String, dynamic> data) {
    _routePayload(jsonEncode(
      data.map((k, v) => MapEntry(k, v?.toString() ?? '')),
    ));
  }

  void _routePayload(String payload) {
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map) {
        final data = decoded.map((k, v) => MapEntry(k.toString(), '$v'));
        onTap?.call(data);
      }
    } catch (_) {}
  }

  /// Kênh 3: lên lịch 1 thông báo cục bộ lúc 08:00 cho các giỗ/sinh nhật
  /// hôm nay. Gọi lại mỗi khi app mở / có dữ liệu gia phả để cập nhật.
  Future<void> scheduleTodaysAnniversaries({
    required int familyId,
    required List<MemberEntity> members,
  }) async {
    // Luôn xoá lịch cũ trước (kể cả khi đang tắt loại này).
    final id = 80000 + familyId;
    await _local.cancel(id, tag: 'family_$familyId');

    if (members.isEmpty) return;
    if (!await NotificationSettingsStore.anniversaryEnabled()) return;

    final today = DateTime.now();
    final todayLunar = Lunar(createdFromSolar: true, date: today);
    final deaths = <String>[];
    final births = <String>[];

    for (final m in members) {
      if (!m.isAlive) {
        int? day;
        int? month;
        final lunar = m.lunarDeathDate;
        if (lunar != null && lunar.isNotEmpty) {
          final match = RegExp(r'(\d+)\/(\d+)').firstMatch(lunar);
          if (match != null) {
            day = int.tryParse(match.group(1) ?? '');
            month = int.tryParse(match.group(2) ?? '');
          }
        }
        if (day == null || month == null) {
          final solar = m.dateOfDeath;
          if (solar != null && solar.isNotEmpty) {
            try {
              final parts = solar.split('-');
              if (parts.length == 3) {
                final y = int.parse(parts[0]);
                final mo = int.parse(parts[1]);
                final d = int.parse(parts[2]);
                final l =
                    Lunar(createdFromSolar: true, date: DateTime(y, mo, d));
                day = l.day;
                month = l.month;
              }
            } catch (_) {}
          }
        }
        if (day != null &&
            month != null &&
            day == todayLunar.day &&
            month == todayLunar.month) {
          deaths.add(m.fullName);
        }
      } else {
        final dob = m.dateOfBirth;
        if (dob != null && dob.isNotEmpty) {
          try {
            final parts = dob.split('-');
            if (parts.length == 3) {
              final mo = int.parse(parts[1]);
              final d = int.parse(parts[2]);
              if (d == today.day && mo == today.month) births.add(m.fullName);
            }
          } catch (_) {}
        }
      }
    }

    if (deaths.isEmpty && births.isEmpty) return;

    final parts = <String>[];
    if (deaths.isNotEmpty) parts.add('ngày giỗ của ${deaths.join(', ')}');
    if (births.isNotEmpty) parts.add('sinh nhật của ${births.join(', ')}');

    final title = (deaths.isNotEmpty && births.isNotEmpty)
        ? 'Giỗ & Sinh nhật hôm nay'
        : (deaths.isNotEmpty ? 'Ngày giỗ hôm nay' : 'Sinh nhật hôm nay');
    final body = 'Hôm nay là ${parts.join(' và ')}.';

    final now = tz.TZDateTime.now(tz.local);
    var fire = tz.TZDateTime(tz.local, now.year, now.month, now.day, 8);
    if (!fire.isAfter(now)) fire = fire.add(const Duration(days: 1));

    await _local.zonedSchedule(
      id,
      title,
      body,
      fire,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: jsonEncode({
        'type': NotifType.anniversary,
        'familyId': '$familyId',
        'title': title,
        'body': body,
      }),
    );
  }
}

/// Handler nền của firebase_messaging — chạy trong isolate riêng, không dùng
/// được singleton. Khởi tạo lại plugin và kiểm tra cài đặt từ SharedPreferences.
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  final plugin = FlutterLocalNotificationsPlugin();
  const android = AndroidInitializationSettings('@mipmap/launcher_icon');
  await plugin.initialize(const InitializationSettings(android: android));

  final data = message.data.map((k, v) => MapEntry(k, v ?? ''));
  final type = data['type'];
  final eventType = (data['eventType'] ?? '').toLowerCase();
  bool? enabled;
  switch (type) {
    case NotifType.event:
      if (eventType == 'announcement' ||
          eventType == 'notification' ||
          eventType == 'thông báo') {
        enabled = await NotificationSettingsStore.announcementEnabled();
      } else {
        enabled = await NotificationSettingsStore.eventEnabled();
      }
      break;
    case NotifType.wish:
      enabled = await NotificationSettingsStore.wishEnabled();
      break;
    case NotifType.anniversary:
      enabled = await NotificationSettingsStore.anniversaryEnabled();
      break;
    default:
      enabled = true;
  }
  if (enabled != true) return;

  final title = data['title'] ?? 'Gia Tộc Việt';
  final body = data['body'] ?? 'Có thông báo mới từ dòng họ';
  final id = (data['id'] ?? data['memberId'] ?? data['type'] ?? 'x').hashCode;

  await plugin.show(
    id,
    title,
    body,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        NotificationService.channelId,
        NotificationService.channelName,
        importance: Importance.high,
      ),
    ),
    payload: jsonEncode(data),
  );
}
