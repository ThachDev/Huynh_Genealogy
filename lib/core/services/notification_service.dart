import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../data/repository/notification_settings_store.dart';
import '../../features/family_tree/domain/entities/member_entity.dart';
import '../errors/failures.dart';
import 'notification/anniversary_scheduler.dart';
import 'notification/notification_content.dart';

export 'notification/notification_content.dart' show NotifType;

/// Façade quản lý thông báo: đăng ký FCM token, nhận tin (foreground/
/// background), hiển thị bằng [FlutterLocalNotificationsPlugin] tôn trọng cài
/// đặt từng loại, lên lịch giỗ/sinh nhật và điều hướng khi tap.
///
/// Các trách nhiệm con đã tách ra:
///   - [NotificationContentBuilder]: xây nội dung thông báo.
///   - [AnniversaryScheduler]: lên lịch giỗ/sinh nhật.
class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const String channelId = NotificationChannel.id;
  static const String channelName = NotificationChannel.name;

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final NotificationContentBuilder _content =
      const NotificationContentBuilder();
  late final AnniversaryScheduler _scheduler =
      AnniversaryScheduler(local: _local, content: _content);

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
    await _show(map, _content.titleFor(map), _content.bodyFor(map));
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

  /// Lên lịch thông báo giỗ/sinh nhật hôm nay. Uỷ quyền cho
  /// [AnniversaryScheduler].
  Future<void> scheduleTodaysAnniversaries({
    required int familyId,
    required List<MemberEntity> members,
  }) {
    return _scheduler.scheduleTodaysAnniversaries(
      familyId: familyId,
      members: members,
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

  final title = data['title'] ??
    AppLanguage.current?.appTitle ??
    'Gia Tộc Việt';
  final body = data['body'] ??
      AppLanguage.current?.notifGenericBody ??
      'Có thông báo mới từ dòng họ';
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