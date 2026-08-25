import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../resources/app_localizations.dart';

/// Mở popup thắp nén nhang với hiệu ứng thắp nén hương, khói tỏa và tàn nhang nhẹ nhàng.
Future<String?> showIncenseDialog(
  BuildContext context, {
  required String targetName,
  String? subtitle,
}) {
  return showDialog<String>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.65),
    builder: (_) => IncenseOfferingDialog(
      targetName: targetName,
      subtitle: subtitle,
    ),
  );
}

class IncenseOfferingDialog extends StatefulWidget {

  const IncenseOfferingDialog({
    super.key,
    required this.targetName,
    this.subtitle,
  });
  final String targetName;
  final String? subtitle;

  @override
  State<IncenseOfferingDialog> createState() => _IncenseOfferingDialogState();
}

class _IncenseOfferingDialogState extends State<IncenseOfferingDialog>
    with SingleTickerProviderStateMixin {
  final TextEditingController _prayerController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isLit = false;
  bool _isFinished = false;
  int _burnKey = 0;
  Uint8List? _webpBytes;

  // Animation controller cho tiến trình thắp & tàn nhang (đồng bộ theo độ dài âm thanh soundTranquil ~6.6s)
  late final AnimationController _burnController;
  late final Animation<double> _glowPulse;

  @override
  void initState() {
    super.initState();
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    _loadWebpBytes();

    // 6635ms khớp chính xác với thời lượng file soundTranquil.mp3
    _burnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6635),
    );

    _glowPulse = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.4), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.1), weight: 45),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 0.3), weight: 30),
    ]).animate(_burnController);

    _burnController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          setState(() {
            _isFinished = true;
          });
        }
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            Navigator.of(context).pop(_prayerController.text);
          }
        });
      }
    });
  }

  Future<void> _loadWebpBytes() async {
    try {
      final ByteData data =
          await rootBundle.load('assets/images/bat_huong.webp');
      if (mounted) {
        setState(() {
          _webpBytes = data.buffer.asUint8List();
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    _burnController.dispose();
    _prayerController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(
        const AssetImage('assets/images/bat_huong_thumb.png'), context);
  }

  void _lightIncense() async {
    if (_isLit) return;
    FocusScope.of(context).unfocus();
    // Xóa triệt để cache hình ảnh động để Flutter khởi tạo lại Codec từ frame 0
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
    setState(() {
      _isLit = true;
      _burnKey++;
    });

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('sound/soundTranquil.mp3'));
    } catch (_) {}

    _burnController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.primary;
    final accentGold = context.accent;
    final l10n = AppLocalizations.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 380),
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withValues(alpha: context.isDarkMode ? 0.4 : 0.12),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── 1. Header Trang Trọng: [Flame] Tên + Ngày & Nút X ──
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8.5),
                decoration: BoxDecoration(
                  color: primaryColor,
                ),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.flame,
                      size: 18,
                      color: Color(0xFFFDE68A),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.targetName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.15,
                            ),
                          ),
                          if (widget.subtitle != null &&
                              widget.subtitle!.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              widget.subtitle!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withValues(alpha: 0.82),
                                height: 1.15,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.x,
                          size: 16, color: Colors.white),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── 2. Khu Vực Lư Hương 3D & 3 Nén Nhang Đốt Tàn Thật ────────────
                    RepaintBoundary(
                      child: Container(
                        height: 230,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              accentGold.withValues(alpha: 0.05),
                              accentGold.withValues(alpha: 0.14),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:
                                context.textSecondary.withValues(alpha: 0.15),
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Ảnh tĩnh ban đầu hoặc Animation WebP trong suốt khi thắp
                            Positioned.fill(
                              child: _isLit
                                  ? (_webpBytes != null
                                      ? Image.memory(
                                          _webpBytes!,
                                          key: ValueKey(
                                              'bat_huong_mem_$_burnKey'),
                                          fit: BoxFit.contain,
                                        )
                                      : Image.asset(
                                          'assets/images/bat_huong.webp',
                                          key: ValueKey(
                                              'bat_huong_webp_$_burnKey'),
                                          fit: BoxFit.contain,
                                        ))
                                  : Image.asset(
                                      'assets/images/bat_huong_thumb.png',
                                      fit: BoxFit.contain,
                                    ),
                            ),

                            // Hiệu ứng ánh sáng hào quang tâm linh ấm áp khi thắp
                            if (_isLit)
                              AnimatedBuilder(
                                animation: _burnController,
                                builder: (context, _) {
                                  return Positioned(
                                    top: 20,
                                    child: Container(
                                      width: 140,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFFFF6B00)
                                                .withValues(
                                              alpha: (0.25 * _glowPulse.value)
                                                  .clamp(0.0, 0.5),
                                            ),
                                            blurRadius: 50,
                                            spreadRadius: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),

                            // Badge trạng thái nhang (Chỉ hiện khi đang thắp - Top Right gọn gàng)
                            if (_isLit)
                              Positioned(
                                top: 10,
                                right: 12,
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 300),
                                  opacity: 1.0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.black.withValues(alpha: 0.65),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color:
                                            accentGold.withValues(alpha: 0.45),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: context.error,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          _isFinished
                                              ? l10n.incenseLitStatus
                                              : l10n.incenseLightingStatus,
                                          style: GoogleFonts.inter(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFFFDE68A),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ── 3. Ô Nhập Lời Khấn / Lời Tưởng Nhớ ──────────────────────
                    TextField(
                      controller: _prayerController,
                      maxLines: 2,
                      enabled: !_isLit,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: context.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.incensePrayerHint,
                        hintStyle: GoogleFonts.inter(
                          fontSize: 12,
                          color: context.textSecondary.withValues(alpha: 0.55),
                        ),
                        filled: true,
                        fillColor: context.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: context.textSecondary.withValues(alpha: 0.2),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: context.textSecondary.withValues(alpha: 0.2),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: context.primary,
                            width: 1.2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── 4. Nút Hành Động: Hủy & Thắp Nhang ──────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isLit
                                ? null
                                : () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(
                                color: context.textSecondary
                                    .withValues(alpha: 0.25),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              l10n.closeButton,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: context.textSecondary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: _isLit ? null : _lightIncense,
                            icon: Icon(
                              _isLit ? LucideIcons.sparkles : LucideIcons.flame,
                              size: 16,
                              color: Colors.white,
                            ),
                            label: Text(
                              _isLit
                                  ? (_isFinished
                                      ? l10n.incenseOfferedLabel
                                      : l10n.incenseOfferingLabel)
                                  : l10n.incenseLightButton,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              disabledBackgroundColor:
                                  primaryColor.withValues(alpha: 0.65),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: _isLit ? 0 : 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
