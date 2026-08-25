import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:vnlunar/vnlunar.dart';
import '../../data/repository/notification_settings_store.dart';
import '../../../features/family_tree/domain/entities/member_entity.dart';
import 'notification_content.dart';

/// Lên lịch thông báo cục bộ lúc 08:00 cho các giỗ/sinh nhật hôm nay.
/// Tách khỏi [NotificationService] để mỗi module quản lý một trách nhiệm.
class AnniversaryScheduler {
  AnniversaryScheduler({
    required FlutterLocalNotificationsPlugin local,
    NotificationContentBuilder? content,
  })  : _local = local,
        _content = content ?? const NotificationContentBuilder();

  final FlutterLocalNotificationsPlugin _local;
  final NotificationContentBuilder _content;

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
                final l = Lunar(createdFromSolar: true, date: DateTime(y, mo, d));
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

    final text = _content.anniversaryText(deaths: deaths, births: births);

    final now = tz.TZDateTime.now(tz.local);
    var fire = tz.TZDateTime(tz.local, now.year, now.month, now.day, 8);
    if (!fire.isAfter(now)) fire = fire.add(const Duration(days: 1));

    await _local.zonedSchedule(
      id,
      text.title,
      text.body,
      fire,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationChannel.id,
          NotificationChannel.name,
          importance: Importance.high,
          priority: Priority.high,
          sound: RawResourceAndroidNotificationSound('sound_noti'),
        ),
        iOS: DarwinNotificationDetails(
          sound: 'soundNoti.mp3',
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: jsonEncode({
        'type': NotifType.anniversary,
        'familyId': '$familyId',
        'title': text.title,
        'body': text.body,
      }),
    );
  }
}