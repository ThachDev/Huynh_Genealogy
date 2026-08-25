import 'package:audioplayers/audioplayers.dart';

/// Service quản lý âm thanh trong toàn bộ ứng dụng (thông báo, hiệu ứng tâm linh...).
class AppSoundService {
  AppSoundService._();

  static final AudioPlayer _notiPlayer = AudioPlayer();

  /// Phát âm thanh thông báo mới
  static Future<void> playNotificationSound() async {
    try {
      await _notiPlayer.stop();
      await _notiPlayer.setSource(AssetSource('sound/soundNoti.mp3'));
      await _notiPlayer.resume();
    } catch (_) {}
  }

  /// Tạo và cấu hình AudioPlayer phát âm thanh tâm linh (thắp nhang)
  static AudioPlayer createTranquilPlayer() {
    final player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);
    return player;
  }
}
