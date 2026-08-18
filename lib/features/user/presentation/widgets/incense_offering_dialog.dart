import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/theme_extensions.dart';

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
  final String targetName;
  final String? subtitle;

  const IncenseOfferingDialog({
    super.key,
    required this.targetName,
    this.subtitle,
  });

  @override
  State<IncenseOfferingDialog> createState() => _IncenseOfferingDialogState();
}

class _IncenseOfferingDialogState extends State<IncenseOfferingDialog>
    with SingleTickerProviderStateMixin {
  final TextEditingController _prayerController = TextEditingController();
  bool _isLit = false;
  bool _isFinished = false;

  // Animation controller cho tiến trình thắp & tàn nhang (khi nhấn "Thắp Nhang")
  late final AnimationController _burnController;
  late final Animation<double> _glowPulse;

  @override
  void initState() {
    super.initState();

    _burnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4800),
    );

    _glowPulse = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.4), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.3), weight: 30),
    ]).animate(_burnController);

    _burnController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isFinished = true;
        });
        Future.delayed(const Duration(milliseconds: 900), () {
          if (mounted) {
            Navigator.of(context).pop(_prayerController.text);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _burnController.dispose();
    _prayerController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(
        const AssetImage('assets/images/bat_huong_thumb.png'), context);
    precacheImage(const AssetImage('assets/images/bat_huong.webp'), context);
  }

  void _lightIncense() {
    if (_isLit) return;
    FocusScope.of(context).unfocus();
    setState(() => _isLit = true);
    _burnController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.primary;
    final accentGold = context.accent;

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
              // ── 1. Header Trang Trọng ──────────────────────────────────────
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8.5),
                decoration: BoxDecoration(
                  color: primaryColor,
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.flame,
                        size: 15, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'THẮP NÉN TÂM NHANG',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.6,
                        ),
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
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Tên người được thắp nhang
                    Text(
                      widget.targetName,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: context.textPrimary,
                      ),
                    ),
                    if (widget.subtitle != null &&
                        widget.subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        widget.subtitle!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: context.textSecondary,
                        ),
                      ),
                    ],

                    const SizedBox(height: 14),

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
                            width: 1,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Ảnh tĩnh ban đầu hoặc Animation WebP trong suốt khi thắp
                            Positioned.fill(
                              child: _isLit
                                  ? Image.asset(
                                      'assets/images/bat_huong.webp',
                                      fit: BoxFit.contain,
                                      gaplessPlayback: true,
                                    )
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

                            // Text trạng thái nhang (Bỏ background khi chưa thắp)
                            Positioned(
                              top: 10,
                              right: 12,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: _isLit ? 1.0 : 0.8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: _isLit
                                      ? BoxDecoration(
                                          color: Colors.black
                                              .withValues(alpha: 0.6),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: accentGold.withValues(
                                                alpha: 0.4),
                                          ),
                                        )
                                      : null,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _isLit
                                              ? const Color(0xFFEF4444)
                                              : context.textSecondary
                                                  .withValues(alpha: 0.6),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        _isLit
                                            ? (_isFinished
                                                ? 'Tâm nguyện đã gửi'
                                                : 'Đang dâng hương...')
                                            : 'Chưa thắp',
                                        style: GoogleFonts.inter(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w600,
                                          color: _isLit
                                              ? const Color(0xFFFDE68A)
                                              : context.textSecondary,
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
                        hintText:
                            'Nhập lời khấn nguyện / tâm nguyện thành kính...',
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
                              'Đóng',
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
                                  ? 'Đang Dâng Hương...'
                                  : 'Thắp Nhang Thành Kính',
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
