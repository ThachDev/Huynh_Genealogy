import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A custom painter that draws an elegant East-Asian / Vietnamese genealogy
/// themed background: parchment gradient + subtle lattice + scattered lotus
/// petals + dragon-cloud swirls + a faint radial vignette.
class TreeBackgroundPainter extends CustomPainter {
  final double animationValue; // 0.0 → 1.0, used for gentle pulsing

  const TreeBackgroundPainter({this.animationValue = 0.0});

  // ─── Palette ────────────────────────────────────────────────────────────────
  static const Color _parchment1 = Color(0xFFF4EBD0);
  static const Color _parchment2 = Color(0xFFEDD5A3);
  static const Color _gold = Color(0xFFD4AF37);
  static const Color _crimson = Color(0xFF8B0000);
  static const Color _wood = Color(0xFF4B2E1E);
  static const Color _softGold = Color(0x18D4AF37); // very transparent
  static const Color _softCrimson = Color(0x0C8B0000); // very transparent

  @override
  void paint(Canvas canvas, Size size) {
    _drawRadialGradientBase(canvas, size);
    _drawLatticeGrid(canvas, size);
    _drawDiagonalLines(canvas, size);
    _drawCornerMandala(canvas, size, const Offset(0, 0));
    _drawCornerMandala(canvas, size, Offset(size.width, 0));
    _drawCornerMandala(canvas, size, Offset(0, size.height));
    _drawCornerMandala(canvas, size, Offset(size.width, size.height));
    _drawScatteredLotus(canvas, size);
    _drawDragonSwirls(canvas, size);
    _drawVignette(canvas, size);
  }

  // ── 1. Base radial gradient (warm parchment centre → slightly darker edge) ──
  void _drawRadialGradientBase(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.1,
        colors: const [_parchment1, _parchment2],
        stops: const [0.0, 1.0],
      ).createShader(rect);

    canvas.drawRect(rect, paint);
  }

  // ── 2. Subtle orthogonal lattice (thin gold lines) ───────────────────────────
  void _drawLatticeGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _softGold
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    const spacing = 48.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  // ── 3. Diagonal cross-hatch (gives a woven silk / brocade feel) ──────────────
  void _drawDiagonalLines(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _softCrimson
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const step = 80.0;
    final diag = math.sqrt(size.width * size.width + size.height * size.height);

    for (double offset = -diag; offset < diag * 2; offset += step) {
      canvas.drawLine(Offset(offset, 0), Offset(offset + size.height, size.height), paint);
      canvas.drawLine(Offset(offset + size.height, 0), Offset(offset, size.height), paint);
    }
  }

  // ── 4. Corner mandala / decorative rosette ───────────────────────────────────
  void _drawCornerMandala(Canvas canvas, Size size, Offset corner) {
    const radius = 90.0;
    // Clamp centre inside canvas
    final cx = corner.dx == 0 ? -radius * 0.4 : size.width + radius * 0.4;
    final cy = corner.dy == 0 ? -radius * 0.4 : size.height + radius * 0.4;
    final centre = Offset(cx, cy);

    final paintFill = Paint()
      ..color = _softGold
      ..style = PaintingStyle.fill;
    final paintStroke = Paint()
      ..color = _gold.withValues(alpha: 0.18)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Concentric arcs
    for (double r = radius; r > 10; r -= 18) {
      canvas.drawCircle(centre, r, paintStroke);
    }

    // Petal fan (8-fold symmetry)
    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * math.pi * 2;
      final path = Path();
      final p1 = Offset(
        centre.dx + math.cos(angle) * radius * 0.9,
        centre.dy + math.sin(angle) * radius * 0.9,
      );
      final p2 = Offset(
        centre.dx + math.cos(angle + math.pi / 8) * radius * 0.5,
        centre.dy + math.sin(angle + math.pi / 8) * radius * 0.5,
      );
      path.moveTo(centre.dx, centre.dy);
      path.quadraticBezierTo(p2.dx, p2.dy, p1.dx, p1.dy);
      path.close();
      canvas.drawPath(path, paintFill);
    }

    // Centre dot
    canvas.drawCircle(centre, 6, paintFill);
  }

  // ── 5. Scattered lotus flowers ───────────────────────────────────────────────
  void _drawScatteredLotus(Canvas canvas, Size size) {
    final positions = [
      Offset(size.width * 0.15, size.height * 0.22),
      Offset(size.width * 0.82, size.height * 0.18),
      Offset(size.width * 0.28, size.height * 0.75),
      Offset(size.width * 0.72, size.height * 0.68),
      Offset(size.width * 0.50, size.height * 0.10),
      Offset(size.width * 0.05, size.height * 0.55),
      Offset(size.width * 0.93, size.height * 0.50),
      Offset(size.width * 0.50, size.height * 0.90),
    ];

    for (final pos in positions) {
      _drawLotus(canvas, pos, 22.0);
    }
  }

  void _drawLotus(Canvas canvas, Offset centre, double r) {
    final petalFill = Paint()
      ..color = _crimson.withValues(alpha: 0.055)
      ..style = PaintingStyle.fill;
    final petalStroke = Paint()
      ..color = _gold.withValues(alpha: 0.12)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    // 6 petals
    for (int i = 0; i < 6; i++) {
      final angle = (i / 6) * math.pi * 2 - math.pi / 2;
      final petalTip = Offset(
        centre.dx + math.cos(angle) * r,
        centre.dy + math.sin(angle) * r,
      );
      final ctrl = Offset(
        centre.dx + math.cos(angle - math.pi / 6) * r * 0.6,
        centre.dy + math.sin(angle - math.pi / 6) * r * 0.6,
      );
      final ctrl2 = Offset(
        centre.dx + math.cos(angle + math.pi / 6) * r * 0.6,
        centre.dy + math.sin(angle + math.pi / 6) * r * 0.6,
      );
      final path = Path()
        ..moveTo(centre.dx, centre.dy)
        ..cubicTo(ctrl.dx, ctrl.dy, ctrl2.dx, ctrl2.dy, petalTip.dx, petalTip.dy)
        ..close();
      canvas.drawPath(path, petalFill);
      canvas.drawPath(path, petalStroke);
    }

    // Centre circle
    canvas.drawCircle(
      centre,
      r * 0.18,
      Paint()..color = _gold.withValues(alpha: 0.20),
    );
  }

  // ── 6. Dragon-cloud swirl curves ─────────────────────────────────────────────
  void _drawDragonSwirls(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _gold.withValues(alpha: 0.08)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final swirls = [
      _buildSwirl(Offset(size.width * 0.1, size.height * 0.05), 60, 0.3),
      _buildSwirl(Offset(size.width * 0.85, size.height * 0.08), 50, -0.5),
      _buildSwirl(Offset(size.width * 0.65, size.height * 0.92), 55, 0.8),
      _buildSwirl(Offset(size.width * 0.2, size.height * 0.88), 45, -0.2),
    ];

    for (final path in swirls) {
      canvas.drawPath(path, paint);
    }
  }

  Path _buildSwirl(Offset origin, double scale, double rotation) {
    final path = Path();
    // Parametric Archimedean spiral approximated with cubic beziers
    final cosR = math.cos(rotation);
    final sinR = math.sin(rotation);

    Offset rotate(Offset p) => Offset(
          p.dx * cosR - p.dy * sinR + origin.dx,
          p.dx * sinR + p.dy * cosR + origin.dy,
        );

    const turns = 2.5;
    const steps = 20;

    for (int i = 0; i < steps; i++) {
      final t0 = i / steps * math.pi * 2 * turns;
      final t1 = (i + 1) / steps * math.pi * 2 * turns;
      final r0 = scale * (i / steps);
      final r1 = scale * ((i + 1) / steps);

      final p0 = rotate(Offset(r0 * math.cos(t0), r0 * math.sin(t0)));
      final p1 = rotate(Offset(r1 * math.cos(t1), r1 * math.sin(t1)));
      final ctrl = rotate(Offset(
        (r0 + r1) / 2 * math.cos((t0 + t1) / 2),
        (r0 + r1) / 2 * math.sin((t0 + t1) / 2),
      ));

      if (i == 0) path.moveTo(p0.dx, p0.dy);
      path.quadraticBezierTo(ctrl.dx, ctrl.dy, p1.dx, p1.dy);
    }
    return path;
  }

  // ── 7. Soft radial vignette (darkens edges subtly) ───────────────────────────
  void _drawVignette(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.85,
        colors: [
          Colors.transparent,
          _wood.withValues(alpha: 0.10),
        ],
        stops: const [0.55, 1.0],
      ).createShader(rect);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(TreeBackgroundPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
