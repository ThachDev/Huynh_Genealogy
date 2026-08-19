import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../resources/app_localizations.dart';

/// Mở popup lá thư để user nhập lời chúc. Trả về nội dung đã nhập,
/// hoặc null nếu đóng mà không gửi.
Future<String?> showWishLetterDialog(
  BuildContext context, {
  required String title,
  required String subtitle,
  required bool isBirthday,
}) {
  return showDialog<String>(
    context: context,
    barrierColor: Colors.black54,
    builder: (_) => WishLetterDialog(
      title: title,
      subtitle: subtitle,
      isBirthday: isBirthday,
    ),
  );
}

class WishLetterDialog extends StatefulWidget {

  const WishLetterDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isBirthday,
  });
  final String title;
  final String subtitle;
  final bool isBirthday;

  @override
  State<WishLetterDialog> createState() => _WishLetterDialogState();
}

class _WishLetterDialogState extends State<WishLetterDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  /// Giai đoạn gấp lá thư + phong bì hiện ra.
  late final Animation<double> _fold;

  /// Phong bì hiện lên (0 → 1).
  late final Animation<double> _envIn;

  /// Nắp phong bì đóng lại (0 → 1).
  late final Animation<double> _flap;

  /// Giai đoạn bay đi.
  late final Animation<double> _rise;
  late final Animation<double> _drift;
  late final Animation<double> _flyAngle;
  late final Animation<double> _flyScale;
  late final Animation<double> _flyOpacity;

  final TextEditingController _message = TextEditingController();
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fold = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.easeInCubic),
    );
    _envIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.15, 0.5, curve: Curves.easeOut),
    );
    _flap = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.6, curve: Curves.easeInOut),
    );

    final flyCurve = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 1.0, curve: Curves.easeIn),
    );
    _rise = TweenSequence<double>([
      // Nhún nhẹ xuống trước khi bay (anticipation)
      TweenSequenceItem(tween: Tween(begin: 0, end: 0.02), weight: 10),
      // Bay lên nhanh dần
      TweenSequenceItem(tween: Tween(begin: 0.02, end: -0.9), weight: 90),
    ]).animate(flyCurve);
    _drift = Tween<double>(begin: 0, end: 0.16).animate(flyCurve);
    _flyAngle = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.55, 1.0, curve: Curves.easeIn),
      ),
    );
    _flyScale = Tween<double>(begin: 1, end: 0.82).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );
    _flyOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _message.dispose();
    super.dispose();
  }

  void _send() {
    if (_sending) return;
    FocusScope.of(context).unfocus();
    setState(() => _sending = true);
    _controller.forward().whenComplete(() {
      if (mounted) Navigator.of(context).pop(_message.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isBirthday = widget.isBirthday;
    final icon = isBirthday ? LucideIcons.cake : LucideIcons.flame;
    final screenH = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final dy = screenH * _rise.value;
          final dx = screenH * _drift.value;
          final angle = _flyAngle.value;
          final scale = _flyScale.value;
          final opacity = _flyOpacity.value;
          final envIn = _envIn.value;
          final flap = _flap.value;
          final fold = _fold.value;

          return Transform.translate(
            offset: Offset(dx, dy),
            child: Transform.rotate(
              angle: angle,
              child: Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: SizedBox(
                    width: 320,
                    height: 380,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // ── Phong bì (hiện ra sau khi bấm gửi) ──
                        IgnorePointer(
                          child: Opacity(
                            opacity: envIn,
                            child: Transform.scale(
                              scale: 0.86 + 0.14 * envIn,
                              child: _Envelope(flapProgress: flap),
                            ),
                          ),
                        ),
                        // ── Lá thư (nội dung lời chúc) ──
                        AnimatedBuilder(
                          animation: _fold,
                          builder: (context, _) {
                            return Opacity(
                              opacity: 1 - fold,
                              child: Transform.translate(
                                offset: Offset(0, 22 * fold),
                                child: Transform.scale(
                                  scaleY: 1 - 0.9 * fold,
                                  child: _LetterContent(
                                    title: widget.title,
                                    subtitle: widget.subtitle,
                                    isBirthday: isBirthday,
                                    icon: icon,
                                    controller: _message,
                                    sending: _sending,
                                    onSend: _send,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Nội dung lá thư: tiêu đề, tên, ngày và ô nhập lời chúc.
class _LetterContent extends StatelessWidget {

  const _LetterContent({
    required this.title,
    required this.subtitle,
    required this.isBirthday,
    required this.icon,
    required this.controller,
    required this.sending,
    required this.onSend,
  });
  final String title;
  final String subtitle;
  final bool isBirthday;
  final IconData icon;
  final TextEditingController controller;
  final bool sending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final dialogTitle =
        isBirthday ? l10n.wishDialogTitle : l10n.anniversaryDialogTitle;
    final dialogHint =
        isBirthday ? l10n.wishDialogHint : l10n.anniversaryDialogHint;

    return Container(
      width: 320,
      height: 400,
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(alpha: context.isDarkMode ? 0.4 : 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // ── 1. Header Strip đồng bộ phong cách hệ thống ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.5),
            color: context.primary,
            child: Row(
              children: [
                Icon(icon, size: 15, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    dialogTitle.toUpperCase(),
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                if (!sending)
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Padding(
                      padding: EdgeInsets.all(2),
                      child: Icon(
                        LucideIcons.x,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── 2. Tên người nhận + Ngày Dương lịch ──
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.calendar,
                        size: 13,
                        color: context.primary,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: context.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ── 3. Ô nhập lời chúc tinh tế & dễ nhìn ──
                  Expanded(
                    child: TextField(
                      controller: controller,
                      enabled: !sending,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        color: context.textPrimary,
                        height: 1.4,
                      ),
                      decoration: InputDecoration(
                        hintText: dialogHint,
                        hintStyle: GoogleFonts.inter(
                          fontSize: 12.5,
                          color: context.textSecondary.withValues(alpha: 0.55),
                        ),
                        filled: true,
                        fillColor: context.background,
                        contentPadding: const EdgeInsets.all(12),
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
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── 4. Nút Hành động: Hủy & Gửi Lời Chúc ──
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: sending
                              ? null
                              : () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            side: BorderSide(
                              color:
                                  context.textSecondary.withValues(alpha: 0.25),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            l10n.cancelLabel,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: context.textSecondary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: sending ? null : onSend,
                          icon: const Icon(LucideIcons.send,
                              size: 15, color: Colors.white),
                          label: Text(
                            l10n.wishSendButton,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.primary,
                            disabledBackgroundColor:
                                context.primary.withValues(alpha: 0.65),
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: sending ? 0 : 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Hình phong bì vẽ bằng CustomPaint, có nắp đóng dần theo [flapProgress].
class _Envelope extends StatelessWidget {

  const _Envelope({required this.flapProgress});
  final double flapProgress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 380,
      child: CustomPaint(
        painter: _EnvelopePainter(
          bodyColor: context.surface,
          accent: context.accent,
          primary: context.primary,
          flapProgress: flapProgress,
        ),
      ),
    );
  }
}

class _EnvelopePainter extends CustomPainter {

  _EnvelopePainter({
    required this.bodyColor,
    required this.accent,
    required this.primary,
    required this.flapProgress,
  });
  final Color bodyColor;
  final Color accent;
  final Color primary;
  final double flapProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(16),
    );

    // Bóng đổ
    canvas.drawShadow(
      Path()..addRRect(rrect),
      Colors.black.withValues(alpha: 0.15),
      6,
      false,
    );

    // Thân phong bì
    canvas.drawRRect(rrect, Paint()..color = bodyColor);

    // Viền vàng
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = accent.withValues(alpha: 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );

    final topLeft = Offset(w * 0.08, h * 0.08);
    final topRight = Offset(w * 0.92, h * 0.08);
    final bottomLeft = Offset(w * 0.08, h * 0.92);
    final bottomRight = Offset(w * 0.92, h * 0.92);
    final center = Offset(w * 0.5, h * 0.5);

    // Đường gấp tạo hình chữ V (nửa dưới)
    final seamPaint = Paint()
      ..color = accent.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    final leftSeam = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(bottomLeft.dx, bottomLeft.dy);
    canvas.drawPath(leftSeam, seamPaint);

    final rightSeam = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(bottomRight.dx, bottomRight.dy);
    canvas.drawPath(rightSeam, seamPaint);

    // Nắp phong bì: tam giác từ mép trên đóng dần xuống giữa
    final apexY = h * 0.08 + (center.dy - h * 0.08) * flapProgress;
    final apex = Offset(center.dx, apexY);

    final flapPath = Path()
      ..moveTo(topLeft.dx, topLeft.dy)
      ..lineTo(apex.dx, apex.dy)
      ..lineTo(topRight.dx, topRight.dy)
      ..close();

    if (flapProgress > 0) {
      canvas.drawPath(
        flapPath,
        Paint()
          ..color = primary.withValues(alpha: 0.05)
          ..style = PaintingStyle.fill,
      );
      final flapEdge = Paint()
        ..color = accent.withValues(alpha: 0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6;
      final edgePath = Path()
        ..moveTo(topLeft.dx, topLeft.dy)
        ..lineTo(apex.dx, apex.dy)
        ..lineTo(topRight.dx, topRight.dy);
      canvas.drawPath(edgePath, flapEdge);
    }

    // Con dấu sáp ở giữa
    canvas.drawCircle(center, 9, Paint()..color = accent);
    canvas.drawCircle(center, 4.5, Paint()..color = primary);
  }

  @override
  bool shouldRepaint(covariant _EnvelopePainter oldDelegate) =>
      oldDelegate.bodyColor != bodyColor ||
      oldDelegate.accent != accent ||
      oldDelegate.primary != primary ||
      oldDelegate.flapProgress != flapProgress;
}
